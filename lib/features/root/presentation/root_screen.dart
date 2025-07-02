import 'package:flutter/material.dart';
import 'package:linchpin/features/duties/presentation/duties_screen.dart';
import 'package:linchpin/features/growth/presentation/growth_screen.dart';
import 'package:linchpin/features/performance_report/presentation/last_quarter_report_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/features/time_management/presentation/time_management_screen.dart';
import 'package:linchpin/features/visitor/presentation/visitor_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
  static late ValueNotifier<int> itemSelectedNotifire;
  static late ValueNotifier<String?> timeServerNotofire;
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  bool isActive = true;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    RootScreen.itemSelectedNotifire = ValueNotifier(0);
    RootScreen.timeServerNotofire = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    RootScreen.itemSelectedNotifire.dispose();
    RootScreen.timeServerNotofire.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(
        context,
        false,
        () => Navigator.pop(context),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: RootScreen.itemSelectedNotifire,
        builder: (context, value, child) {
          return isActive
              ? IndexedStack(
                  index: value, // تعیین اینکه کدام تب فعال باشه

                  children: [
                    TimeManagementScreen(),
                    DutiesScreen(),
                    LastQuarterReportScreen(),
                    GrowthScreen(),
                    VisitorScreen(),
                  ],
                )
              : IndexedStack(
                  index: value, // تعیین اینکه کدام تب فعال باشه

                  children: [
                    TimeManagementScreen(),
                    DutiesScreen(),
                    LastQuarterReportScreen(),
                    GrowthScreen(),
                  ],
                );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color:
                  Color(0xff828282).withValues(alpha: 0.20), // میزان تیرگی سایه
              blurRadius: 100, // میزان محوشدگی سایه
              spreadRadius: 0, // میزان گسترش سایه
              offset: Offset(0, 8), // جهت سایه (افقی، عمودی)
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ValueListenableBuilder(
            valueListenable: RootScreen.itemSelectedNotifire,
            builder: (context, value, child) {
              return Theme(
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
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    RootScreen.itemSelectedNotifire.value = value;
                  },
                  items: isActive
                      ? [
                          BottomNavigationBarItem(
                            icon: value == 0
                                ? Assets.icons.clockAddPlusA.svg()
                                : Assets.icons.clockAddPlus.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 1
                                ? Assets.icons.boardTasksA.svg()
                                : Assets.icons.boardTasks.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 2
                                ? Assets.icons.activityA.svg()
                                : Assets.icons.activity.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 3
                                ? Assets.icons.leaves.svg()
                                : Assets.icons.leavesOff.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 4
                                ? Assets.icons.leaves.svg()
                                : Assets.icons.leavesOff.svg(),
                            label: "",
                          ),
                        ]
                      : [
                          BottomNavigationBarItem(
                            icon: value == 0
                                ? Assets.icons.clockAddPlusA.svg()
                                : Assets.icons.clockAddPlus.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 1
                                ? Assets.icons.boardTasksA.svg()
                                : Assets.icons.boardTasks.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 2
                                ? Assets.icons.activityA.svg()
                                : Assets.icons.activity.svg(),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: value == 3
                                ? Assets.icons.leaves.svg()
                                : Assets.icons.leavesOff.svg(),
                            label: "",
                          ),
                        ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
