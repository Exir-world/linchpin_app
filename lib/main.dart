import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/features/auth/presentation/auth_screen.dart';
import 'package:linchpin_app/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin_app/features/growth/presentation/bloc/growth_bloc.dart';

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
        BlocProvider<DutiesBloc>(
          create: (context) => getIt<DutiesBloc>(),
        ),
        BlocProvider<GrowthBloc>(
          create: (context) => getIt<GrowthBloc>(),
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
        home: const AuthScreen(),
      ),
    );
  }
}
