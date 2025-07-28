import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart';
import 'package:linchpin/features/visitor/data/models/response/set_location_response.dart';
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/domain/use_case/getlocation_usecase.dart';
import 'package:linchpin/features/visitor/domain/use_case/setlocation_usecase.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'visitor_event.dart';
part 'visitor_state.dart';

@injectable
class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final SetLocationUseCase setLocationUseCase;
  final GetlocationUsecase getlocationUsecase;

  bool isDeleted = false;
  XFile? photo;
  List<File> capturedImages = [];
  List<MultipartFile> multipartImages = [];
  FormData? formData;
  SetLocationResponse visitors = SetLocationResponse();
  LatLng? currentLocation;
  List<CurrentLocationEntity> visitTargets = [];
  final desc = BehaviorSubject<String?>.seeded('');
  final address = BehaviorSubject<String?>.seeded("آدرس مشخص نشده");
  final selectedValue =
      BehaviorSubject<CurrentLocationEntity>.seeded(CurrentLocationEntity());
  List<Items> items = [];

  VisitorBloc(this.setLocationUseCase, this.getlocationUsecase)
      : super(VisitorInitial()) {
    on<SetLocationEvent>(_saveLocationEvent);
    on<UploadImage>(_uploadImage);
    on<GetLocation>(_getLocation);
  }

  FutureOr<void> _saveLocationEvent(
      SetLocationEvent event, Emitter<VisitorState> emit) async {
    try {
      emit(SetLocationLoading());
      DataState dataState = await setLocationUseCase.setLocation(
        event.setLocationRequest ?? SetLocationRequest(),
        // event.setLocationEntity ?? SetLocationEntity(),
      );
      if (dataState is DataSuccess) {
        visitors = dataState.data;
        emit(SetLocationSuccess());
      }

      if (dataState is DataFailed) {
        emit(SetLocationFailure(error: dataState.error));
      }
    } catch (e) {
      emit(SetLocationFailure(error: e.toString()));
    }
  }

  FutureOr<void> _getLocation(
      GetLocation event, Emitter<VisitorState> emit) async {
    try {
      emit(GetLocationLoading());
      DataState dataState = await getlocationUsecase.getLocation();
      if (dataState is DataSuccess) {
        visitTargets.clear();
        items.clear();
        dataState.data
            .map(
              (e) => visitTargets.add(
                CurrentLocationEntity(
                  id: e.id,
                  lat: e.lat,
                  lng: e.lng,
                  latLng: LatLng(
                    double.parse(e.lat.toString()),
                    double.parse(e.lng.toString()),
                  ),
                ),
              ),
            )
            .toList();
        dataState.data
            .map(
              (e) => items.add(
                Items(
                  id: e.id,
                  lat: e.lat,
                  lng: e.lng,
                  checkPointId: e.checkPointId,
                  needReport: e.needReport,
                  radius: e.radius,
                  userCheckPoints: e.userCheckPoints,
                ),
              ),
            )
            .toList();
        emit(GetLocationSuccess());
      }

      if (dataState is DataFailed) {
        emit(SetLocationFailure(error: dataState.error));
      }
    } catch (e) {
      emit(SetLocationFailure(error: e.toString()));
    }
  }

  FutureOr<void> _uploadImage(
      UploadImage event, Emitter<VisitorState> emit) async {
    try {
      emit(UploadImageLoading());
    } catch (e) {}
  }

  void checkTextField(String txt) {
    desc.sink.add(txt);
  }

  Future<void> saveLatLngMap(Map<String, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(map);
    prefs.setString('latlng_map', jsonString);
  }

  Future<Map<String, String>> loadLatLngMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('latlng_map');

    if (jsonString != null) {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    }

    return {};
  }

  Future<bool> isLatLngInMap(double lat, double lng) async {
    final key = '$lat,$lng';
    final map = await loadLatLngMap();
    return map.containsKey(key);
  }

  dispose() async {
    desc.close();
    address.close();
    selectedValue.close();
  }
}
