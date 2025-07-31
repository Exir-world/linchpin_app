import 'package:dio/dio.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/entity/upload_image_entity.dart';

abstract class VisitorRepository {
  Future<DataState<bool>> myVisitor();
  Future<DataState<SetLocationEntity>> setLocation(SetLocationRequest params);
  Future<DataState<List<Items>>> getLocation();
  Future<DataState<List<UploadImageEntity>>> uploadImage(FormData? files);
}
