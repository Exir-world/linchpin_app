import 'package:flutter/material.dart';
import 'package:linchpin_app/features/duties/presentation/duties_screen.dart';
import 'package:linchpin_app/features/performance_report/presentation/last_quarter_report_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/features/time_management/presentation/time_management_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
  static ValueNotifier<int> itemSelectedNotifire = ValueNotifier(1);
  static ValueNotifier<String?> timeServerNotofire = ValueNotifier(null);
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, false),
      body: ValueListenableBuilder<int>(
        valueListenable: RootScreen.itemSelectedNotifire,
        builder: (context, value, child) {
          return IndexedStack(
            index: value, // تعیین اینکه کدام تب فعال باشه
            children: [
              DutiesScreen(),
              TimeManagementScreen(), // صفحه اول
              LastQuarterReportScreen(), // صفحه دوم
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
              );
            },
          ),
        ),
      ),
    );
  }
}
