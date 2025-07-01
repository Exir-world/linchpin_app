import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

part 'visitor_event.dart';
part 'visitor_state.dart';

@injectable
class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc() : super(VisitorInitial()) {
    on<VisitorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
