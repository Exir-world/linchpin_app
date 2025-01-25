import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';
import 'package:linchpin_app/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // locator مربوط به گت ایت و
  await configureDependencies(environment: Env.prod);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fa')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('fa'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<TimeManagementBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<LastQuarterReportBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Color(0xffFAFAFF),
        ),
        home: const RootScreen(),
      ),
    );
  }
}
