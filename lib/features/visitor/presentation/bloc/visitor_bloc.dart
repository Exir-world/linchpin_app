import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/entity/visitor_entity.dart';
import 'package:linchpin/features/visitor/domain/use_case/upload_usecase.dart';
import 'package:rxdart/subjects.dart';

part 'visitor_event.dart';
part 'visitor_state.dart';

@injectable
class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final UploadUsecase uploadUsecase;

  bool isDeleted = false;
  XFile? photo;
  List<File> capturedImages = [];
  List<MultipartFile> multipartImages = [];
  FormData? formData;
  List<VisitorEntity>? visitors = [];
  LatLng? currentLocation;
  final List<LatLng> visitTargets = [
    // LatLng(36.2978512, 59.5906702),
    LatLng(36.2977532, 59.5986680),
    LatLng(36.2977832, 59.5926712),
    LatLng(36.2977532, 59.5945702),
  ];
  final desc = BehaviorSubject<String?>.seeded('');

  VisitorBloc(this.uploadUsecase) : super(VisitorInitial()) {
    on<SaveLocationEvent>(_saveLocationEvent);
    on<UploadImage>(_uploadImage);
  }

  FutureOr<void> _saveLocationEvent(
      SaveLocationEvent event, Emitter<VisitorState> emit) async {
    // try {
    //   emit(SaveLocationLoading());
    //   DataState dataState = await visitorUsecase.myVisitor();
    //   if (dataState is DataSuccess) {
    //     visitors = dataState.data;
    //     emit(SaveLocationSuccess());
    //   }

    //   if (dataState is DataFailed) {
    //     emit(SaveLocationFailure(error: dataState.error));
    //   }
    // } catch (e) {
    //   emit(SaveLocationFailure(error: e.toString()));
    // }
  }

  FutureOr<void> _uploadImage(
      UploadImage event, Emitter<VisitorState> emit) async {
    try {
      emit(UploadImageLoading());
      DataState dataState = await uploadUsecase.visitorRepository
          .uploadImage(event.upload ?? SetLocationEntity());
      if (dataState is DataSuccess) {
        emit(UploadImageSuccess());
      }

      if (dataState is DataFailed) {
        emit(SaveLocationFailure(error: dataState.error!));
      }
    } catch (e) {
      emit(SaveLocationFailure(error: e.toString()));
    }
  }

  void checkTextField(String txt) {
    desc.sink.add(txt);
  }

  dispose() async {
    desc.close();
  }
}
