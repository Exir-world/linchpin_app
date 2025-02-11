import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/loading_widget.dart';
import 'package:linchpin_app/features/duties/presentation/bloc/duties_bloc.dart';
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
      AllDutiesScreen.tabIndexNotifire.value = _tabController.index;
    });
    BlocProvider.of<DutiesBloc>(context).add(AllTasksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DutiesBloc, DutiesState>(
      builder: (context, state) {
        if (state is AllTasksCompleted) {
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
                                    state.tasksEntity.myTasks?.length
                                            .toString() ??
                                        '0',
                                    textColorInLight: Color(0xff861C8C),
                                  )),
                              SizedBox(width: 4),
                              ValueListenableBuilder(
                                valueListenable:
                                    AllDutiesScreen.tabIndexNotifire,
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
                                    state.tasksEntity.otherTasks?.length
                                            .toString() ??
                                        '0',
                                    textColorInLight: Color(0xff861C8C),
                                  )),
                              SizedBox(width: 4),
                              ValueListenableBuilder(
                                valueListenable:
                                    AllDutiesScreen.tabIndexNotifire,
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
                                SizedBox(height: 24),
                                ListView.builder(
                                  itemCount: state.tasksEntity.myTasks?.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 80),
                                  itemBuilder: (context, index) {
                                    final data =
                                        state.tasksEntity.myTasks![index];
                                    return TaskItem(
                                      title: data.title ?? '',
                                      date: data.date ?? '',
                                      tag: data.taskTags!,
                                      flagTitle: data.priority?.title ?? '',
                                      imageFlag: Assets.icons.flag1.svg(),
                                      isOthers: false,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyTaskScreen(),
                                            ));
                                      },
                                      isListTag: false,
                                      icon: data.done!
                                          ? Assets.icons.check.svg(height: 24)
                                          : Container(
                                              width: 17,
                                              height: 17,
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff030712)
                                                        .withValues(
                                                            alpha: 0.12),
                                                    blurRadius: 2.4,
                                                    offset: Offset(0, 1.2),
                                                    spreadRadius: 1.2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      imageUrl: null,
                                      avatarName: null,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 24),
                                ListView.builder(
                                  itemCount:
                                      state.tasksEntity.otherTasks?.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 80),
                                  itemBuilder: (context, index) {
                                    final data =
                                        state.tasksEntity.otherTasks![index];
                                    return TaskItem(
                                      title: data.title ?? '',
                                      date: data.date ?? '',
                                      tag: data.taskTags!,
                                      flagTitle: data.priority?.title ?? '',
                                      imageFlag: Assets.icons.flag1.svg(),
                                      isOthers: true,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyTaskScreen(),
                                            ));
                                      },
                                      isListTag: false,
                                      icon: data.done!
                                          ? Assets.icons.check.svg(height: 24)
                                          : Container(
                                              width: 17,
                                              height: 17,
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff030712)
                                                        .withValues(
                                                            alpha: 0.12),
                                                    blurRadius: 2.4,
                                                    offset: Offset(0, 1.2),
                                                    spreadRadius: 1.2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      imageUrl: null,
                                      avatarName: data.user?.name ?? '',
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
        } else if (state is AllTasksError) {
          return Scaffold(
            body: Center(child: Text(state.textError)),
          );
        } else if (state is AllTasksLoading) {
          return LoadingWidget();
        } else {
          return Scaffold(
            body: Center(child: Text('data')),
          );
        }
      },
    );
  }
}
