import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/property/domain/entity/my_properties_entity.dart';
import 'package:linchpin/features/property/domain/use_case/property_usecase.dart';

part 'property_event.dart';
part 'property_state.dart';

@injectable
class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyUsecase propertyUsecase;
  PropertyBloc(this.propertyUsecase) : super(PropertyInitial()) {
    on<PropertyEvent>(_propertyEvent);
  }

  FutureOr<void> _propertyEvent(
      PropertyEvent event, Emitter<PropertyState> emit) async {
    emit(MyPropertyLoadingState());
    DataState dataState = await propertyUsecase.myProperties();

    if (dataState is DataSuccess) {
      emit(MyPropertyCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(MyPropertyErrorState(dataState.error!));
    }
  }
}
