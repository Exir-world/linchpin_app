import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin_app/features/performance_report/last_quarter_report_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/features/root/presentation/bloc/root_bloc.dart';
import 'package:linchpin_app/features/time_management/time_management_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
  static ValueNotifier<int> itemSelectedNotifire = ValueNotifier(1);
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    PrefService prefService = PrefService();
    prefService.createCacheString(
      SharedKey.jwtToken,
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Miwicm9sZSI6IlVzZXIiLCJpYXQiOjE3MzcyNjUyNTUsImV4cCI6MTczNzM1MTY1NX0.Lkr_ORKj15uzdT_OgbYRfZx6lRfZOjx_4-2zv2yAzDE",
    );
    BlocProvider.of<RootBloc>(context).add(DailyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        if (state is DailyComplitedState) {
          return Scaffold(
            appBar: appBarRoot(context, false),
            body: ValueListenableBuilder(
              valueListenable: RootScreen.itemSelectedNotifire,
              builder: (context, value, child) {
                if (value == 0) {
                  return Center(
                    child: Text('وظایف'),
                  );
                } else if (value == 1) {
                  return TimeManagementScreen();
                } else {
                  return LastQuarterReportScreen();
                }
              },
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: ValueListenableBuilder(
                valueListenable: RootScreen.itemSelectedNotifire,
                builder: (context, value, child) {
                  return SizedBox(
                    height: 72,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent, // حذف رنگ splash
                        highlightColor: Colors.transparent, // حذف رنگ highlight
                      ),
                      child: BottomNavigationBar(
                        showUnselectedLabels: false,
                        showSelectedLabels: false,
                        backgroundColor: Colors.white,
                        currentIndex: value,
                        elevation: 0,
                        onTap: (value) {
                          RootScreen.itemSelectedNotifire.value = value;
                        },
                        items: [
                          BottomNavigationBarItem(
                            icon: value == 0
                                ? Assets.icons.boardTasksA.svg()
                                : Assets.icons.boardTasks.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 1
                                ? Assets.icons.clockAddPlusA.svg()
                                : Assets.icons.clockAddPlus.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 2
                                ? Assets.icons.activityA.svg()
                                : Assets.icons.activity.svg(),
                            label: "",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is DailyLoadingState) {
          return Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        } else if (state is DailyErrorState) {
          return Scaffold(
            body: Center(child: Text(state.errorText)),
          );
        } else {
          return Scaffold(
            body: Center(child: Text('data')),
          );
        }
      },
    );
  }
}
