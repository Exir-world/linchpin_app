import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/snackbar_verify.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:linchpin_app/gen/fonts.gen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
  static late ValueNotifier<TextEditingController> accountControllerNotifire;
  static late ValueNotifier<TextEditingController> passControllerNotifire;
}

class _AuthScreenState extends State<AuthScreen> with WidgetsBindingObserver {
  late AuthBloc _bloc;
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastPressedTime;
  final PrefService prefService = PrefService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _bloc = getIt<AuthBloc>();
    // مقداردهی مجدد در صورت نیاز
    AuthScreen.accountControllerNotifire =
        ValueNotifier(TextEditingController());
    AuthScreen.passControllerNotifire = ValueNotifier(TextEditingController());
    _checkAuthStatus();
    super.initState();
  }

  // بررسی توکن و وضعیت ورود
  Future<void> _checkAuthStatus() async {
    String? token = await prefService.readCacheString(SharedKey.jwtToken);
    if (token == null) {
      // اگر توکن وجود نداشت، صفحه لاگین را نمایش می‌دهیم
      return;
    }

    int? expires = await prefService.readCacheInt(SharedKey.expires);
    if (expires == null ||
        expires * 1000 < DateTime.now().millisecondsSinceEpoch) {
      // اگر توکن منقضی شده بود، صفحه لاگین را نمایش می‌دهیم
      return;
    }

    // اگر توکن معتبر بود، کاربر به صفحه اصلی هدایت می‌شود
    _navigateToRoot();
  }

  void _navigateToRoot() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootScreen()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // ابتدا مقدار داخل ValueNotifier (TextEditingController) را آزاد کنید
    AuthScreen.accountControllerNotifire.value.dispose();
    AuthScreen.passControllerNotifire.value.dispose();

    // حالا خود ValueNotifier را dispose کنید
    AuthScreen.accountControllerNotifire.dispose();
    AuthScreen.passControllerNotifire.dispose();
    _bloc.close();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedTime == null ||
        now.difference(_lastPressedTime!) > Duration(milliseconds: 500)) {
      _lastPressedTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        snackBarVerify(
          context: context,
          title: 'برای خروج، دوبار دکمه خروج را کلیک کنید.',
          desc: '',
          icon: Assets.icons.info.svg(),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginCompletedState) {
            prefService.createCacheString(
                SharedKey.jwtToken, state.loginEntity.accessToken ?? '');
            prefService.createCacheString(
                SharedKey.refreshToken, state.loginEntity.refreshToken ?? '');
            prefService.createCacheInt(
                SharedKey.expires, state.loginEntity.expires ?? 0);
            _navigateToRoot();
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarVerify(
                context: context,
                title: 'خطا در ورود',
                desc: state.errorText,
                icon: Assets.icons.activity.svg(),
              ),
            );
          }
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Assets.images.logo.image(height: 50)),
                      SizedBox(height: 80),
                      NormalMedium('نام کاربری'),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: AuthScreen.accountControllerNotifire.value,
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontFamily: FontFamily.iRANSansXFAMedium,
                          fontSize: 14,
                          color: Color(0xff4f4f4f),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              10), // محدودیت 10 کاراکتر
                          FilteringTextInputFormatter.deny(
                              RegExp(r'^0')), // جلوگیری از شروع با 0
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^[1-9][0-9]*$')), // فقط اعداد بدون صفر در ابتدا
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xffE0E0F9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFF861C8C),
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      NormalMedium('رمز عبور'),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: AuthScreen.passControllerNotifire.value,
                        obscureText: obscureText,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: FontFamily.iRANSansXFAMedium,
                          fontSize: 14,
                          color: Color(0xff4f4f4f),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xffE0E0F9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFF861C8C),
                              width: 1,
                            ),
                          ),
                          prefixIcon: ValueListenableBuilder(
                            valueListenable:
                                AuthScreen.passControllerNotifire.value,
                            builder: (context, value, child) {
                              return value.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obscureText = !obscureText;
                                        });
                                      },
                                      child: Icon(
                                        obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xffCAC4CF),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      GestureDetector(
                        onTap: () {
                          if (AuthScreen.accountControllerNotifire.value.text
                                  .isNotEmpty &&
                              AuthScreen.passControllerNotifire.value.text
                                  .isNotEmpty) {
                            _bloc.add(LoginEvent(
                              phoneNumber: AuthScreen
                                  .accountControllerNotifire.value.text,
                              password:
                                  AuthScreen.passControllerNotifire.value.text,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBarVerify(
                                context: context,
                                title: 'خطا',
                                desc:
                                    'لطفاً نام کاربری و رمز عبور را وارد کنید',
                                icon: Assets.icons.activity.svg(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Color(0xff861C8C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is LoginLoadingState) {
                                return CupertinoActivityIndicator(
                                  color: Colors.white,
                                );
                              } else {
                                return LargeMedium(
                                  'ورود',
                                  textColorInLight: Colors.white,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
