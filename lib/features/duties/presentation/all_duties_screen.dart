import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/duties/presentation/duties_screen.dart';
import 'package:linchpin_app/features/duties/presentation/my_task_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class AllDutiesScreen extends StatefulWidget {
  const AllDutiesScreen({super.key});

  @override
  State<AllDutiesScreen> createState() => _AllDutiesScreenState();
  static ValueNotifier<int> tabIndexNotifire = ValueNotifier(0);
}

class _AllDutiesScreenState extends State<AllDutiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        AllDutiesScreen.tabIndexNotifire.value = _tabController.index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  BigDemiBold('لیست وظایف'),
                  Spacer(),
                  Row(
                    children: [
                      Assets.icons.filter.svg(),
                      SizedBox(width: 8),
                      NormalMedium(
                        'فیلتر کردن',
                        textColorInLight: Color(0xff861C8C),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              TabBar(
                controller: _tabController, // اضافه کردن کنترلر
                indicatorColor: Color(0xff861C8C),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 24,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xffF5EEFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: SmallMedium(
                              '4',
                              textColorInLight: Color(0xff861C8C),
                            )),
                        SizedBox(width: 4),
                        ValueListenableBuilder(
                          valueListenable: AllDutiesScreen.tabIndexNotifire,
                          builder: (context, value, child) {
                            return NormalMedium(
                              'وظایف من',
                              textColorInLight:
                                  value == 0 ? null : Color(0xff828282),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 24,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xffF5EEFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: SmallMedium(
                              '4',
                              textColorInLight: Color(0xff861C8C),
                            )),
                        SizedBox(width: 4),
                        ValueListenableBuilder(
                          valueListenable: AllDutiesScreen.tabIndexNotifire,
                          builder: (context, value, child) {
                            return NormalMedium(
                              'وظایف دیگران',
                              textColorInLight:
                                  value == 1 ? null : Color(0xff828282),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController, // اضافه کردن کنترلر
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            margin: EdgeInsets.only(top: 24, bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xffF5EEFC),
                              borderRadius: BorderRadius.circular(37),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: SmallRegular('امروز'),
                          ),
                          ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 80),
                            itemBuilder: (context, index) {
                              return TaskItem(
                                title: 'تسک ۱ - ۱۳ الی ۱۴:۳۰',
                                date: '۱۴۰۳/۱۱/۲۲',
                                tag: 'دیزاین',
                                flagTitle: 'مهم و فوری',
                                imageFlag: Assets.icons.flag1.svg(),
                                isOthers: false,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyTaskScreen(),
                                      ));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            margin: EdgeInsets.only(top: 24, bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xffF5EEFC),
                              borderRadius: BorderRadius.circular(37),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: SmallRegular('امروز'),
                          ),
                          ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 80),
                            itemBuilder: (context, index) {
                              return TaskItem(
                                title: 'تسک ۱ - ۱۳ الی ۱۴:۳۰',
                                date: '۱۴۰۳/۱۱/۲۲',
                                tag: 'دیزاین',
                                flagTitle: 'مهم و فوری',
                                imageFlag: Assets.icons.flag1.svg(),
                                isOthers: true,
                                onTap: () {},
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
