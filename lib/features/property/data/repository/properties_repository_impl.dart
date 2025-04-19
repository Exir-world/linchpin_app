import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/property/data/data_source/api_property.dart';
import 'package:linchpin/features/property/data/models/my_properties_model/my_properties_model.dart';
import 'package:linchpin/features/property/domain/entity/my_properties_entity.dart';
import 'package:linchpin/features/property/domain/repository/property_repository.dart';

@Singleton(as: PropertyRepository, env: [Env.prod])
class PropertiesRepositoryImpl extends PropertyRepository {
  final ApiProperty apiProperty;

  PropertiesRepositoryImpl(this.apiProperty);
  @override
  Future<DataState<List<MyPropertiesEntity>>> myProperties() async {
    try {
      Response response = await apiProperty.myProperties();
      List<MyPropertiesEntity> myProperties = List<MyPropertiesEntity>.from(
          response.data.map((model) => MyPropertiesModel.fromJson(model)));
      return DataSuccess(myProperties);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
