part of 'requests_bloc.dart';

sealed class RequestsEvent {}

// لیست درخواست های کاربر
class RequestUser extends RequestsEvent {}

// لغو درخواست
class RequestCancelEvent extends RequestsEvent {
  final String id;

  RequestCancelEvent(this.id);
}
