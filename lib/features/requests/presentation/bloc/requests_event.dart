part of 'requests_bloc.dart';

sealed class RequestsEvent {}

// لیست درخواست های کاربر
class RequestUser extends RequestsEvent {}

// لغو درخواست
class RequestCancelEvent extends RequestsEvent {
  final String id;

  RequestCancelEvent(this.id);
}

// لیست نوع درخواست ها
class RequestTypesEvent extends RequestsEvent {}

// ثبت درخواست
class RequestCreateEvent extends RequestsEvent {
  final String type;
  final String? description;
  final String startTime;
  final String? endTime;

  RequestCreateEvent({
    required this.type,
    required this.startTime,
    this.description,
    this.endTime,
  });
}
