import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/duties/presentation/all_duties_screen.dart';
import 'package:linchpin_app/features/duties/presentation/my_task_screen.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class DutiesScreen extends StatefulWidget {
  const DutiesScreen({super.key});

  @override
  State<DutiesScreen> createState() => _DutiesScreenState();
  static ValueNotifier<int> tabIndexNotifire = ValueNotifier(0);
}

class _DutiesScreenState extends State<DutiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        DutiesScreen.tabIndexNotifire.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SizedBox(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          backgroundColor: Color(0xff861C8C),
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {},
        ),
      ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllDutiesScreen(),
                          ));
                    },
                    child: Row(
                      children: [
                        Assets.icons.calendar1.svg(),
                        SizedBox(width: 8),
                        NormalMedium(
                          'مشاهده همه روزها',
                          textColorInLight: Color(0xff861C8C),
                        ),
                      ],
                    ),
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
                          valueListenable: DutiesScreen.tabIndexNotifire,
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
                          valueListenable: DutiesScreen.tabIndexNotifire,
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

class TaskItem extends StatelessWidget {
  final String title;
  final String date;
  final String tag;
  final String flagTitle;
  final Widget imageFlag;
  final bool isOthers;
  final Function() onTap;
  const TaskItem({
    super.key,
    required this.title,
    required this.date,
    required this.tag,
    required this.flagTitle,
    required this.imageFlag,
    required this.isOthers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Assets.icons.check.svg(height: 24),
                SizedBox(width: 8),
                NormalMedium(title),
                Spacer(),
                SmallRegular(date),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                TagContainer(
                  tag: tag,
                  color: Color(0xffB10000),
                ),
                isOthers
                    ? Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Assets.icons.avatar.svg(),
                          ),
                          SizedBox(width: 4),
                          SmallMedium('زهرا'),
                        ],
                      )
                    : Container(),
                Spacer(),
                imageFlag,
                SizedBox(width: 4),
                SmallMedium(
                  flagTitle,
                  textColorInLight: Color(0xffFD5B71),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TagContainer extends StatelessWidget {
  final Color color;
  const TagContainer({
    super.key,
    required this.tag,
    required this.color,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 79,
      height: 26,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: SmallRegular(
        tag,
        textColorInLight: color,
      ),
    );
  }
}
