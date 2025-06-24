import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/snackbar_verify.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
  static ValueNotifier<TextEditingController> accountControllerNotifire =
      ValueNotifier(TextEditingController());
  static ValueNotifier<TextEditingController> passControllerNotifire =
      ValueNotifier(TextEditingController());
}

class _AuthScreenState extends State<AuthScreen> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastPressedTime;
  final PrefService prefService = PrefService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
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

  Future<void> _navigateToRoot() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RootScreen()),
    );
  }

  @override
  void dispose() {
    AuthScreen.accountControllerNotifire.dispose();
    AuthScreen.passControllerNotifire.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedTime == null ||
        now.difference(_lastPressedTime!) > const Duration(milliseconds: 500)) {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is LoginCompletedState) {
          prefService.createCacheString(
            SharedKey.jwtToken,
            state.loginEntity.accessToken ?? '',
          );
          prefService.createCacheString(
            SharedKey.refreshToken,
            state.loginEntity.refreshToken ?? '',
          );
          prefService.createCacheInt(
            SharedKey.expires,
            state.loginEntity.expires ?? 0,
          );
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
                      child: Assets.images.logo.image(height: 50),
                    ),
                    const SizedBox(height: 80),
                    const NormalMedium('نام کاربری'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: AuthScreen.accountControllerNotifire.value,
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0F9),
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const NormalMedium('رمز عبور'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: AuthScreen.passControllerNotifire.value,
                      obscureText: obscureText,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0F9),
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
                                      color: const Color(0xffCAC4CF),
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
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () {
                        if (AuthScreen.accountControllerNotifire.value.text
                                .isNotEmpty &&
                            AuthScreen
                                .passControllerNotifire.value.text.isNotEmpty) {
                          BlocProvider.of<AuthBloc>(context).add(
                            LoginEvent(
                              phoneNumber: AuthScreen
                                  .accountControllerNotifire.value.text,
                              password:
                                  AuthScreen.passControllerNotifire.value.text,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarVerify(
                              context: context,
                              title: 'خطا',
                              desc: 'لطفاً نام کاربری و رمز عبور را وارد کنید',
                              icon: Assets.icons.activity.svg(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xff861C8C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is LoginLoadingState) {
                              return const CupertinoActivityIndicator(
                                color: Colors.white,
                              );
                            } else {
                              return const LargeMedium(
                                'ورود',
                                textColorInLight: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
