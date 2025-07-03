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
import 'package:linchpin/core/common/http_client.dart' as _i735;
import 'package:linchpin/features/auth/data/data_source/api_auth.dart' as _i675;
import 'package:linchpin/features/auth/data/repository/auth_repository_impl.dart'
    as _i472;
import 'package:linchpin/features/auth/domain/repository/auth_repository.dart'
    as _i278;
import 'package:linchpin/features/auth/domain/use_case/auth_usecase.dart'
    as _i817;
import 'package:linchpin/features/auth/presentation/bloc/auth_bloc.dart'
    as _i12;
import 'package:linchpin/features/duties/data/data_source/api_duties.dart'
    as _i96;
import 'package:linchpin/features/duties/data/repository/duties_repository_impl.dart'
    as _i152;
import 'package:linchpin/features/duties/domain/repository/duties_repository.dart'
    as _i479;
import 'package:linchpin/features/duties/domain/use_case/duties_usecase.dart'
    as _i954;
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart'
    as _i1003;
import 'package:linchpin/features/growth/data/data_source/api_growth.dart'
    as _i302;
import 'package:linchpin/features/growth/data/repository/growth_repository_impl.dart'
    as _i493;
import 'package:linchpin/features/growth/domain/repository/growth_repository.dart'
    as _i443;
import 'package:linchpin/features/growth/domain/use_case/growth_usecase.dart'
    as _i71;
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart'
    as _i501;
import 'package:linchpin/features/notifications/data/data_source/api_notifications.dart'
    as _i534;
import 'package:linchpin/features/notifications/data/repository/notifications_repository_impl.dart'
    as _i496;
import 'package:linchpin/features/notifications/domain/repository/notifications_repository.dart'
    as _i127;
import 'package:linchpin/features/notifications/domain/use_case/notifications_usecase.dart'
    as _i106;
import 'package:linchpin/features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i377;
import 'package:linchpin/features/pay_slip/data/data_source/api_pay_slip.dart'
    as _i765;
import 'package:linchpin/features/pay_slip/data/repository/pay_slip_repository_impl.dart'
    as _i967;
import 'package:linchpin/features/pay_slip/domain/repository/pay_slip_repository.dart'
    as _i703;
import 'package:linchpin/features/pay_slip/domain/use_case/pay_slip_usecase.dart'
    as _i375;
import 'package:linchpin/features/pay_slip/presentation/bloc/pay_slip_bloc.dart'
    as _i12;
import 'package:linchpin/features/performance_report/data/data_source/api_last_quarter_report.dart'
    as _i1071;
import 'package:linchpin/features/performance_report/data/repository/last_quarter_report_repository_impl.dart'
    as _i896;
import 'package:linchpin/features/performance_report/domain/repository/last_quarter_report_repository.dart'
    as _i713;
import 'package:linchpin/features/performance_report/domain/use_case/last_quarter_report_usecase.dart'
    as _i46;
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart'
    as _i4;
import 'package:linchpin/features/property/data/data_source/api_property.dart'
    as _i60;
import 'package:linchpin/features/property/data/repository/properties_repository_impl.dart'
    as _i807;
import 'package:linchpin/features/property/domain/repository/property_repository.dart'
    as _i474;
import 'package:linchpin/features/property/domain/use_case/property_usecase.dart'
    as _i761;
import 'package:linchpin/features/property/presentation/bloc/property_bloc.dart'
    as _i616;
import 'package:linchpin/features/requests/data/data_source/api_request.dart'
    as _i554;
import 'package:linchpin/features/requests/data/repository/request_repository_impl.dart'
    as _i629;
import 'package:linchpin/features/requests/domain/repository/request_repository.dart'
    as _i1038;
import 'package:linchpin/features/requests/domain/usecase/request_usecase.dart'
    as _i145;
import 'package:linchpin/features/requests/presentation/bloc/requests_bloc.dart'
    as _i785;
import 'package:linchpin/features/time_management/data/data_source/api_time_mamagement.dart'
    as _i864;
import 'package:linchpin/features/time_management/data/repository/time_management_repository_impl.dart'
    as _i762;
import 'package:linchpin/features/time_management/domain/repository/time_management_repository.dart'
    as _i246;
import 'package:linchpin/features/time_management/domain/use_case/time_management_usecase.dart'
    as _i436;
import 'package:linchpin/features/time_management/presentation/bloc/time_management_bloc.dart'
    as _i658;
import 'package:linchpin/features/visitor/data/api_visitor.dart' as _i547;
import 'package:linchpin/features/visitor/data/repository/visitor_repository.dart'
    as _i989;
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart'
    as _i1051;
import 'package:linchpin/features/visitor/domain/use_case/upload_usecase.dart'
    as _i870;
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart'
    as _i573;

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
    gh.singleton<_i675.ApiAuth>(() => _i675.ApiAuth(gh<_i361.Dio>()));
    gh.singleton<_i96.ApiDuties>(() => _i96.ApiDuties(gh<_i361.Dio>()));
    gh.singleton<_i302.ApiGrowth>(() => _i302.ApiGrowth(gh<_i361.Dio>()));
    gh.singleton<_i534.ApiNotifications>(
        () => _i534.ApiNotifications(gh<_i361.Dio>()));
    gh.singleton<_i765.ApiPaySlip>(() => _i765.ApiPaySlip(gh<_i361.Dio>()));
    gh.singleton<_i1071.ApiLastQuarterReport>(
        () => _i1071.ApiLastQuarterReport(gh<_i361.Dio>()));
    gh.singleton<_i60.ApiProperty>(() => _i60.ApiProperty(gh<_i361.Dio>()));
    gh.singleton<_i554.ApiRequest>(() => _i554.ApiRequest(gh<_i361.Dio>()));
    gh.singleton<_i864.ApiTimeMamagement>(
        () => _i864.ApiTimeMamagement(gh<_i361.Dio>()));
    gh.singleton<_i547.ApiProperty>(() => _i547.ApiProperty(gh<_i361.Dio>()));
    gh.singleton<_i246.TimeManagementRepository>(
      () => _i762.TimeManagementRepositoryImpl(gh<_i864.ApiTimeMamagement>()),
      registerFor: {_prod},
    );
    gh.singleton<_i713.LastQuarterReportRepository>(
      () => _i896.LastQuarterReportRepositoryImpl(
          gh<_i1071.ApiLastQuarterReport>()),
      registerFor: {_prod},
    );
    gh.singleton<_i127.NotificationsRepository>(
      () => _i496.NotificationsRepositoryImpl(gh<_i534.ApiNotifications>()),
      registerFor: {_prod},
    );
    gh.singleton<_i474.PropertyRepository>(
      () => _i807.PropertiesRepositoryImpl(gh<_i60.ApiProperty>()),
      registerFor: {_prod},
    );
    gh.singleton<_i703.PaySlipRepository>(
      () => _i967.PaySlipRepositoryImpl(gh<_i765.ApiPaySlip>()),
      registerFor: {_prod},
    );
    gh.singleton<_i1038.RequestRepository>(
      () => _i629.RequestRepositoryImpl(gh<_i554.ApiRequest>()),
      registerFor: {_prod},
    );
    gh.singleton<_i375.PaySlipUsecase>(
      () => _i375.AuthUsecaseImpl(gh<_i703.PaySlipRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i436.TimeManagementUsecase>(
      () =>
          _i436.TimeManagementUsecaseImpl(gh<_i246.TimeManagementRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i443.GrowthRepository>(
      () => _i493.GrowthRepositoryImpl(gh<_i302.ApiGrowth>()),
      registerFor: {_prod},
    );
    gh.singleton<_i278.AuthRepository>(
      () => _i472.AuthRepositoryImpl(gh<_i675.ApiAuth>()),
      registerFor: {_prod},
    );
    gh.singleton<_i479.DutiesRepository>(
      () => _i152.DutiesRepositoryImpl(gh<_i96.ApiDuties>()),
      registerFor: {_prod},
    );
    gh.singleton<_i1051.VisitorRepository>(
      () => _i989.VisitorRepositoryImpl(),
      registerFor: {_prod},
    );
    gh.factoryAsync<_i361.Response<dynamic>>(
        () => dioProvider.refresh(gh<String>()));
    gh.singleton<_i761.PropertyUsecase>(
      () => _i761.PropertyUsecaseImpl(gh<_i474.PropertyRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i658.TimeManagementBloc>(
        () => _i658.TimeManagementBloc(gh<_i436.TimeManagementUsecase>()));
    gh.singleton<_i870.UploadUsecase>(
      () => _i870.UploadImageImpl(gh<_i1051.VisitorRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i616.PropertyBloc>(
        () => _i616.PropertyBloc(gh<_i761.PropertyUsecase>()));
    gh.factory<_i12.PaySlipBloc>(
        () => _i12.PaySlipBloc(gh<_i375.PaySlipUsecase>()));
    gh.singleton<_i817.AuthUsecase>(
      () => _i817.AuthUsecaseImpl(gh<_i278.AuthRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i954.DutiesUsecase>(
      () => _i954.DutiesUsecaseImpl(gh<_i479.DutiesRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i106.NotificationsUsecase>(
      () => _i106.NotificationsUsecaseImpl(gh<_i127.NotificationsRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i46.LastQuarterReportUsecase>(
      () => _i46.LastQuarterReportUsecaseImpl(
          gh<_i713.LastQuarterReportRepository>()),
      registerFor: {_prod},
    );
    gh.singleton<_i71.GrowthUsecase>(
      () => _i71.GrowthUsecaseUsecaseImpl(gh<_i443.GrowthRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i1003.DutiesBloc>(
        () => _i1003.DutiesBloc(gh<_i954.DutiesUsecase>()));
    gh.singleton<_i145.RequestUsecase>(
      () => _i145.RequestUsecaseImpl(gh<_i1038.RequestRepository>()),
      registerFor: {_prod},
    );
    gh.factory<_i573.VisitorBloc>(
        () => _i573.VisitorBloc(gh<_i870.UploadUsecase>()));
    gh.factory<_i4.LastQuarterReportBloc>(
        () => _i4.LastQuarterReportBloc(gh<_i46.LastQuarterReportUsecase>()));
    gh.factory<_i501.GrowthBloc>(
        () => _i501.GrowthBloc(gh<_i71.GrowthUsecase>()));
    gh.factory<_i12.AuthBloc>(() => _i12.AuthBloc(gh<_i817.AuthUsecase>()));
    gh.factory<_i785.RequestsBloc>(
        () => _i785.RequestsBloc(gh<_i145.RequestUsecase>()));
    gh.factory<_i377.NotificationsBloc>(
        () => _i377.NotificationsBloc(gh<_i106.NotificationsUsecase>()));
    return this;
  }
}

class _$DioProvider extends _i735.DioProvider {}
