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
import 'package:linchpin_app/features/root/data/data_source/api_root.dart'
    as _i371;
import 'package:linchpin_app/features/root/data/repository/root_repository_impl.dart'
    as _i203;
import 'package:linchpin_app/features/root/domain/repository/root_repository.dart'
    as _i205;
import 'package:linchpin_app/features/root/domain/use_case/root_usecase.dart'
    as _i950;
import 'package:linchpin_app/features/root/presentation/bloc/root_bloc.dart'
    as _i793;

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
    gh.singleton<_i371.ApiRoot>(() => _i371.ApiRoot(gh<_i361.Dio>()));
    gh.singleton<_i205.RootRepository>(
      () => _i203.RootRepositoryImpl(gh<_i371.ApiRoot>()),
      registerFor: {_prod},
    );
    gh.singleton<_i950.RootUsecase>(
        () => _i950.RootUsecase(gh<_i205.RootRepository>()));
    gh.factory<_i793.RootBloc>(() => _i793.RootBloc(gh<_i950.RootUsecase>()));
    return this;
  }
}

class _$DioProvider extends _i738.DioProvider {}
