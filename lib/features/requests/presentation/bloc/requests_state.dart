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
