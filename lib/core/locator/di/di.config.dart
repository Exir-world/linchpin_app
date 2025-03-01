// dart format width=80
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
import 'package:linchpin/core/common/http_client.dart' as _i113;
import 'package:linchpin/features/auth/data/data_source/api_auth.dart' as _i57;
import 'package:linchpin/features/auth/data/repository/auth_repository_impl.dart'
    as _i664;
import 'package:linchpin/features/auth/domain/repository/auth_repository.dart'
    as _i670;
import 'package:linchpin/features/auth/domain/use_case/auth_usecase.dart'
    as _i354;
import 'package:linchpin/features/auth/presentation/bloc/auth_bloc.dart'
    as _i332;
import 'package:linchpin/features/duties/data/data_source/api_duties.dart'
    as _i718;
import 'package:linchpin/features/duties/data/repository/duties_repository_impl.dart'
    as _i937;
import 'package:linchpin/features/duties/domain/repository/duties_repository.dart'
    as _i76;
import 'package:linchpin/features/duties/domain/use_case/duties_usecase.dart'
    as _i71;
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart'
    as _i73;
import 'package:linchpin/features/growth/data/data_source/api_growth.dart'
    as _i628;
import 'package:linchpin/features/growth/data/repository/growth_repository_impl.dart'
    as _i517;
import 'package:linchpin/features/growth/domain/repository/growth_repository.dart'
    as _i640;
import 'package:linchpin/features/growth/domain/use_case/growth_usecase.dart'
    as _i708;
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart'
    as _i66;
import 'package:linchpin/features/notifications/data/data_source/api_notifications.dart'
    as _i27;
import 'package:linchpin/features/notifications/data/repository/notifications_repository_impl.dart'
    as _i680;
import 'package:linchpin/features/notifications/domain/repository/notifications_repository.dart'
    as _i643;
import 'package:linchpin/features/notifications/domain/use_case/notifications_usecase.dart'
    as _i856;
import 'package:linchpin/features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i560;
import 'package:linchpin/features/performance_report/data/data_source/api_last_quarter_report.dart'
    as _i799;
import 'package:linchpin/features/performance_report/data/repository/last_quarter_report_repository_impl.dart'
    as _i99;
import 'package:linchpin/features/performance_report/domain/repository/last_quarter_report_repository.dart'
    as _i514;
import 'package:linchpin/features/performance_report/domain/use_case/last_quarter_report_usecase.dart'
    as _i644;
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart'
    as _i873;
import 'package:linchpin/features/requests/data/data_source/api_request.dart'
    as _i1058;
import 'package:linchpin/features/requests/data/repository/request_repository_impl.dart'
    as _i1037;
import 'package:linchpin/features/requests/domain/repository/request_repository.dart'
    as _i163;
import 'package:linchpin/features/requests/domain/usecase/request_usecase.dart'
    as _i116;
import 'package:linchpin/features/requests/presentation/bloc/requests_bloc.dart'
    as _i15;
import 'package:linchpin/features/time_management/data/data_source/api_time_mamagement.dart'
    as _i105;
import 'package:linchpin/features/time_management/data/repository/time_management_repository_impl.dart'
    as _i469;
import 'package:linchpin/features/time_management/domain/repository/time_management_repository.dart'
    as _i150;
import 'package:linchpin/features/time_management/domain/use_case/time_management_usecase.dart'
    as _i893;
import 'package:linchpin/features/time_management/presentation/bloc/time_management_bloc.dart'
    as _i519;

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
    gh.singleton<_i57.ApiAuth>(() => _i57.ApiAuth(gh<_i361.Dio>()));
    gh.singleton<_i718.ApiDuties>(() => _i718.ApiDuties(gh<_i361.Dio>()));
    gh.singleton<_i628.ApiGrowth>(() => _i628.ApiGrowth(gh<_i361.Dio>()));
    gh.singleton<_i27.ApiNotifications>(
        () => _i27.ApiNotifications(gh<_i361.Dio>()));
    gh.singleton<_i799.ApiLastQuarterReport>(
        () => _i799.ApiLastQuarterReport(gh<_i361.Dio>()));
    gh.singleton<_i1058.ApiRequest>(() => _i1058.ApiRequest(gh<_i361.Dio>()));
    gh.singleton<_i105.ApiTimeMamagement>(
        () => _i105.ApiTimeMamagement(gh<_i361.Dio>()));
    gh.singleton<_i150.TimeManagementRepository>(
      () => _i469.TimeManagementRepositoryImpl(gh<_i105.ApiTimeMamagement>()),
      registerFor: {_prod},
    );
    gh.singleton<_i514.LastQuarterReportRepository>(
      () => _i99.LastQuarterReportRepositoryImpl(
          gh<_i799.ApiLastQuarterReport>()),
      registerFor: {_prod},
    );
    gh.singleton<_i640.GrowthRepository>(
      () => _i517.GrowthRepositoryImpl(gh<_i628.ApiGrowth>()),
      registerFor: {_prod},
    );
    gh.singleton<_i893.TimeManagementUsecase>(
      () =>
          _i893.TimeManagementUsecaseImpl(gh<_i150.TimeManagementRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i708.GrowthUsecase>(
      () => _i708.GrowthUsecaseUsecaseImpl(gh<_i640.GrowthRepository>()),
      registerFor: {_prod},
    );
    gh.factoryAsync<_i361.Response<dynamic>>(
        () => dioProvider.refresh(gh<String>()));
    gh.factory<_i519.TimeManagementBloc>(
        () => _i519.TimeManagementBloc(gh<_i893.TimeManagementUsecase>()));
    gh.singleton<_i670.AuthRepository>(
      () => _i664.AuthRepositoryImpl(gh<_i57.ApiAuth>()),
      registerFor: {_prod},
    );
    gh.singleton<_i163.RequestRepository>(
      () => _i1037.RequestRepositoryImpl(gh<_i1058.ApiRequest>()),
      registerFor: {_prod},
    );
    gh.singleton<_i76.DutiesRepository>(
      () => _i937.DutiesRepositoryImpl(gh<_i718.ApiDuties>()),
      registerFor: {_prod},
    );
    gh.singleton<_i643.NotificationsRepository>(
      () => _i680.NotificationsRepositoryImpl(gh<_i27.ApiNotifications>()),
      registerFor: {_prod},
    );
    gh.singleton<_i644.LastQuarterReportUsecase>(
      () => _i644.LastQuarterReportUsecaseImpl(
          gh<_i514.LastQuarterReportRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i354.AuthUsecase>(
      () => _i354.AuthUsecaseImpl(gh<_i670.AuthRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i332.AuthBloc>(() => _i332.AuthBloc(gh<_i354.AuthUsecase>()));
    gh.factory<_i66.GrowthBloc>(
        () => _i66.GrowthBloc(gh<_i708.GrowthUsecase>()));
    gh.singleton<_i116.RequestUsecase>(
      () => _i116.RequestUsecaseImpl(gh<_i163.RequestRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i71.DutiesUsecase>(
      () => _i71.DutiesUsecaseImpl(gh<_i76.DutiesRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i873.LastQuarterReportBloc>(() =>
        _i873.LastQuarterReportBloc(gh<_i644.LastQuarterReportUsecase>()));
    gh.singleton<_i856.NotificationsUsecase>(
      () => _i856.NotificationsUsecaseImpl(gh<_i643.NotificationsRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i560.NotificationsBloc>(
        () => _i560.NotificationsBloc(gh<_i856.NotificationsUsecase>()));
    gh.factory<_i15.RequestsBloc>(
        () => _i15.RequestsBloc(gh<_i116.RequestUsecase>()));
    gh.factory<_i73.DutiesBloc>(
        () => _i73.DutiesBloc(gh<_i71.DutiesUsecase>()));
    return this;
  }
}

class _$DioProvider extends _i113.DioProvider {}
