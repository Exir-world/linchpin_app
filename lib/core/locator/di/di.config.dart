// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:linchpin_app/core/common/http_client.dart' as _i738;
import 'package:linchpin_app/features/time_management/data/data_source/api_time_mamagement.dart'
    as _i526;
import 'package:linchpin_app/features/time_management/data/repository/time_management_repository_impl.dart'
    as _i400;
import 'package:linchpin_app/features/time_management/domain/repository/time_management_repository.dart'
    as _i1063;
import 'package:linchpin_app/features/time_management/domain/use_case/time_management_usecase.dart'
    as _i781;
import 'package:linchpin_app/features/time_management/presentation/bloc/time_management_bloc.dart'
    as _i134;

const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioProvider = _$DioProvider();
    gh.factory<_i361.Dio>(() => dioProvider.httpclient);
    gh.singleton<_i526.ApiTimeMamagement>(
        () => _i526.ApiTimeMamagement(gh<_i361.Dio>()));
    gh.singleton<_i1063.TimeManagementRepository>(
      () => _i400.TimeManagementRepositoryImpl(gh<_i526.ApiTimeMamagement>()),
      registerFor: {_prod},
    );
    gh.singleton<_i781.TimeManagementUsecase>(() =>
        _i781.TimeManagementUsecase(gh<_i1063.TimeManagementRepository>()));
    gh.factory<_i134.TimeManagementBloc>(
        () => _i134.TimeManagementBloc(gh<_i781.TimeManagementUsecase>()));
    return this;
  }
}

class _$DioProvider extends _i738.DioProvider {}
