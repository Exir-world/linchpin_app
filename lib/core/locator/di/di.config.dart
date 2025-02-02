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
import 'package:linchpin_app/features/performance_report/data/data_source/api_last_quarter_report.dart'
    as _i146;
import 'package:linchpin_app/features/performance_report/data/repository/last_quarter_report_repository_impl.dart'
    as _i356;
import 'package:linchpin_app/features/performance_report/domain/repository/last_quarter_report_repository.dart'
    as _i133;
import 'package:linchpin_app/features/performance_report/domain/use_case/last_quarter_report_usecase.dart'
    as _i285;
import 'package:linchpin_app/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart'
    as _i981;
import 'package:linchpin_app/features/requests/data/data_source/api_request.dart'
    as _i862;
import 'package:linchpin_app/features/requests/data/repository/request_repository_impl.dart'
    as _i150;
import 'package:linchpin_app/features/requests/domain/repository/request_repository.dart'
    as _i688;
import 'package:linchpin_app/features/requests/domain/usecase/request_usecase.dart'
    as _i171;
import 'package:linchpin_app/features/requests/presentation/bloc/requests_bloc.dart'
    as _i1041;
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
    gh.singleton<_i146.ApiLastQuarterReport>(
        () => _i146.ApiLastQuarterReport(gh<_i361.Dio>()));
    gh.singleton<_i862.ApiRequest>(() => _i862.ApiRequest(gh<_i361.Dio>()));
    gh.singleton<_i526.ApiTimeMamagement>(
        () => _i526.ApiTimeMamagement(gh<_i361.Dio>()));
    gh.singleton<_i688.RequestRepository>(
      () => _i150.RequestRepositoryImpl(gh<_i862.ApiRequest>()),
      registerFor: {_prod},
    );
    gh.singleton<_i171.RequestUsecase>(
        () => _i171.RequestUsecase(gh<_i688.RequestRepository>()));
    gh.singleton<_i1063.TimeManagementRepository>(
      () => _i400.TimeManagementRepositoryImpl(gh<_i526.ApiTimeMamagement>()),
      registerFor: {_prod},
    );
    gh.singleton<_i133.LastQuarterReportRepository>(
      () => _i356.LastQuarterReportRepositoryImpl(
          gh<_i146.ApiLastQuarterReport>()),
      registerFor: {_prod},
    );
    gh.singleton<_i781.TimeManagementUsecase>(() =>
        _i781.TimeManagementUsecase(gh<_i1063.TimeManagementRepository>()));
    gh.factory<_i1041.RequestsBloc>(
        () => _i1041.RequestsBloc(gh<_i171.RequestUsecase>()));
    gh.factory<_i134.TimeManagementBloc>(
        () => _i134.TimeManagementBloc(gh<_i781.TimeManagementUsecase>()));
    gh.singleton<_i285.LastQuarterReportUsecase>(() =>
        _i285.LastQuarterReportUsecase(
            gh<_i133.LastQuarterReportRepository>()));
    gh.factory<_i981.LastQuarterReportBloc>(() =>
        _i981.LastQuarterReportBloc(gh<_i285.LastQuarterReportUsecase>()));
    return this;
  }
}

class _$DioProvider extends _i738.DioProvider {}
