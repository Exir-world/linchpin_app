import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin_app/features/time_management/time_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(useMaterial3: true),
      home: const TimeManagementScreen(),
    );
  }
}
