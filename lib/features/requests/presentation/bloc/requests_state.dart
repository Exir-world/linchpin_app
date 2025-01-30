part of 'requests_bloc.dart';

sealed class RequestsState {}

final class RequestsLoading extends RequestsState {}

final class RequestsCompleted extends RequestsState {
  final List<RequestUserEntity> requestUserEntity;

  RequestsCompleted(this.requestUserEntity);
}

final class RequestsError extends RequestsState {
  final String textError;

  RequestsError(this.textError);
}

// لغو درخواست
final class RequestCancelLoading extends RequestsState {}

final class RequestCancelCompleted extends RequestsState {
  final SuccessEntity successEntity;

  RequestCancelCompleted(this.successEntity);
}

final class RequestCancelError extends RequestsState {
  final String textError;

  RequestCancelError(this.textError);
}

final class RequestTypesLoading extends RequestsState {}

final class RequestTypesCompleted extends RequestsState {
  final List<RequestTypesEntity> requestTypesEntity;

  RequestTypesCompleted(this.requestTypesEntity);
}

final class RequestTypesError extends RequestsState {
  final String textError;

  RequestTypesError(this.textError);
}

// ثبت درخواست
final class RequestCreateLoading extends RequestsState {}

final class RequestCreateCompleted extends RequestsState {
  final RequestCreateEntity requestCreateEntity;

  RequestCreateCompleted(this.requestCreateEntity);
}

final class RequestCreateError extends RequestsState {
  final String textError;

  RequestCreateError(this.textError);
}
