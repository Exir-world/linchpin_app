import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/visitor/data/datasource/api_getLocation.dart';
import 'package:linchpin/features/visitor/data/datasource/api_uploadimage.dart';
import 'package:linchpin/features/visitor/data/datasource/api_visitor.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart';
import 'package:linchpin/features/visitor/data/models/response/set_location_response.dart';
import 'package:linchpin/features/visitor/domain/entity/get_location_entity.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/entity/upload_image_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

@Singleton(as: VisitorRepository, env: [Env.prod])
class VisitorRepositoryImpl extends VisitorRepository {
  final ApiVisitor apiVisitor;
  final ApiGetlocation apiGetlocation;
  final ApiUploadimage apiUploadimage;

  VisitorRepositoryImpl(
    this.apiVisitor,
    this.apiGetlocation,
    this.apiUploadimage,
  );
  @override
  Future<DataState<bool>> myVisitor() async {
    // TODO: implement myVisitor
    throw UnimplementedError();
  }

  @override
  Future<DataState<SetLocationEntity>> setLocation(
      SetLocationRequest params) async {
    try {
      Response response = await apiVisitor.myVisitor(params);
      SetLocationEntity setLocationEntity =
          SetLocationResponse.fromJson(response.data);
      return DataSuccess(setLocationEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<List<Items>>> getLocation() async {
    try {
      Response response = await apiGetlocation.getLocation();
      GetLocationEntity getLocationEntity =
          GetLocationImpl.fromJson(response.data);
      return DataSuccess(getLocationEntity.itemsEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<List<UploadImageEntity>>> uploadImage(
      List<String>? files) async {
    Response response = await apiUploadimage.uploadImage(files);
    final uploadImage = <UploadImageEntity>[];
    return DataSuccess(uploadImage);
  }
}
