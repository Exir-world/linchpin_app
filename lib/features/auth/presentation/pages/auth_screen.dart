import 'package:calendar_pro_farhad/core/context_extension.dart';
import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/customui/snackbar_verify.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:linchpin/gen/fonts.gen.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with WidgetsBindingObserver {
  late AuthBloc _bloc;
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastPressedTime;
  TextEditingController accountController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final PrefService prefService = PrefService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _bloc = getIt<AuthBloc>();
    // مقداردهی مجدد در صورت نیاز
    accountController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // حالا خود ValueNotifier را dispose کنید
    accountController.dispose();
    passController.dispose();
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
          title: LocaleKeys.exitText.tr(),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RootScreen()),
            );
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarVerify(
                context: context,
                title: LocaleKeys.loginError.tr(),
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
              child: SingleChildScrollView(
                child: SizedBox(
                  height: context.screenHeight,
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
                          NormalMedium(LocaleKeys.userName.tr()),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: accountController,
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
                          NormalMedium(LocaleKeys.password.tr()),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: passController,
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
                              prefixIcon: GestureDetector(
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
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 48),
                          GestureDetector(
                            onTap: () {
                              if (accountController.text.isNotEmpty &&
                                  passController.value.text.isNotEmpty) {
                                _bloc.add(LoginEvent(
                                  phoneNumber: accountController.value.text,
                                  password: passController.value.text,
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarVerify(
                                    context: context,
                                    title: LocaleKeys.error.tr(),
                                    desc: LocaleKeys.pleasePassword.tr(),
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
                                      LocaleKeys.login.tr(),
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
        ),
      ),
    );
  }
}
