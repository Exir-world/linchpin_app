import 'package:linchpin/core/common/text_styles.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/utils/max_width_wrapper.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/auth/presentation/auth_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linchpin/features/pay_slip/presentation/bloc/pay_slip_bloc.dart';
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // locator مربوط به گت ایت و
  await configureDependencies(environment: Env.prod);
  // // ابتدا بررسی موقعیت مکانی قبل از اجرای اپلیکیشن
  // LocationService locationService = LocationService();
  // Widget homePage = await locationService.checkLocationPermission();

  // مقدار زبان انتخاب‌شده را از SharedPreferences بخوانیم
  PrefService prefService = PrefService();
  String? savedLanguage =
      await prefService.readCacheString(SharedKey.selectedLanguage);

  // تعیین زبان پیش‌فرض بر اساس مقدار ذخیره‌شده
  Locale initialLocale = _getLocaleFromLanguage(savedLanguage);
  await FontHelper.loadLanguage(); // مقداردهی اولیه زبان
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fa'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: initialLocale,
      child: MyApp(),
    ),
  );
}

// تابع برای تبدیل نام زبان به Locale
Locale _getLocaleFromLanguage(String? language) {
  AuthScreen.languageNotifire.value = language ?? 'fa';
  switch (language) {
    case 'fa':
      return Locale('fa');
    case 'en':
      return Locale('en');
    case 'ar':
      return Locale('ar');
    default:
      return Locale('fa');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _homePageFuture;

  @override
  void initState() {
    super.initState();
    _homePageFuture = _getHomePage();
  }

  // این متد بررسی موقعیت مکانی و تعیین صفحه خانگی را انجام می دهد
  Future<Widget> _getHomePage() async {
    LocationService locationService = LocationService();
    return await locationService.checkLocationPermission();
  }

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
        BlocProvider<LastQuarterReportBloc>(
          create: (context) => getIt<LastQuarterReportBloc>(),
        ),
        BlocProvider<PaySlipBloc>(
          create: (context) => getIt<PaySlipBloc>(),
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
        builder: (context, child) {
          return MaxWidthWrapper(
            maxWidth: 500,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: FutureBuilder<Widget>(
          future: _homePageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // در حال بارگذاری
              return MaxWidthWrapper(
                child: Scaffold(
                  body: SafeArea(child: LoadingWidget()),
                ),
              );
            } else if (snapshot.hasError) {
              return MaxWidthWrapper(
                child: Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                ),
              );
            } else if (snapshot.hasData) {
              // پس از بررسی و تعیین صفحه خانگی
              return MaxWidthWrapper(child: snapshot.data!);
            } else {
              return MaxWidthWrapper(
                child: Scaffold(
                  body: Center(child: Text('No data available')),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// نرم افزار ما به علت تردد، نیاز به موقعیت مکانی کاربر دارد..
class LocationService {
  // بررسی و درخواست موقعیت مکانی
  Future<Widget> checkLocationPermission() async {
    try {
      // کاربر دسترسی به جی پی اس موبایل داده یا نه؟
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // اگر کاربر دسترسی نداده بود ولی می تونست دسترسی بده
        return AccessLocationScreen();
      } else if (permission == LocationPermission.deniedForever) {
        // اگر دسترسی برای همیشه رد شده، صفحه دسترسی رو باز کن
        return AccessLocationScreen();
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // لوکیشن کاربر روشن هست یا نه؟
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // اگر خاموش بود
          return AccessLocationScreen();
        } else {
          // اگر موقعیت مکانی روشن است، صفحه AuthScreen رو برگردون
          Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
          );
          AccessLocationScreen.latitudeNotifire.value = position.latitude;
          AccessLocationScreen.longitudeNotifire.value = position.longitude;
          return AuthScreen();
        }
      }
    } catch (e) {
      // در صورت خطا، صفحه دسترسی رو باز کن
      return AccessLocationScreen();
    }
    // در صورتی که هیچکدام از شرایط بالا برقرار نبود (برای مثال برای خطای احتمالی دیگر)
    return AccessLocationScreen(); // مقدار پیش‌فرض در صورتی که هیچکدام از شرایط اجرا نشد
  }
}
