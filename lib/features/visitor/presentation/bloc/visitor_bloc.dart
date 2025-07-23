import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/set_location_response.dart';
import 'package:linchpin/features/visitor/domain/use_case/getlocation_usecase.dart';
import 'package:linchpin/features/visitor/domain/use_case/setlocation_usecase.dart';
import 'package:rxdart/subjects.dart';

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
  final List<LatLng> visitTargets = [
    // LatLng(36.2978512, 59.5906702),
    LatLng(36.2977532, 59.5986680),
    LatLng(36.2977832, 59.5926712),
    LatLng(36.2977532, 59.5945702),
  ];
  final desc = BehaviorSubject<String?>.seeded('');

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

  dispose() async {
    desc.close();
  }
}
