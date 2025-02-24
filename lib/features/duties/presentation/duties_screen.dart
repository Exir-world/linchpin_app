import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Linchpin/core/common/text_widgets.dart';
import 'package:Linchpin/core/customui/loading_widget.dart';
import 'package:Linchpin/core/extension/context_extension.dart';
import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/features/duties/data/models/tasks_model/task_tag.dart';
import 'package:Linchpin/features/duties/presentation/all_duties_screen.dart';
import 'package:Linchpin/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:Linchpin/features/duties/presentation/my_task_screen.dart';
import 'package:Linchpin/gen/assets.gen.dart';

class DutiesScreen extends StatefulWidget {
  const DutiesScreen({super.key});

  @override
  State<DutiesScreen> createState() => _DutiesScreenState();
  static late ValueNotifier<int> tabIndexNotifire;
}

class _DutiesScreenState extends State<DutiesScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late DutiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 1, vsync: this);
    DutiesScreen.tabIndexNotifire = ValueNotifier(0);
    _bloc = getIt<DutiesBloc>();

    _tabController.addListener(() {
      DutiesScreen.tabIndexNotifire.value = _tabController.index;
    });
    _bloc.add(TasksEvent(
      startDate: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
      endDate: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    DutiesScreen.tabIndexNotifire.dispose();
    _tabController.dispose();
    _bloc.close();
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
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: SizedBox(
          height: 56,
          width: 56,
          child: FloatingActionButton(
            backgroundColor: Color(0xff861C8C),
            shape: CircleBorder(),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                  color: Color(0xff861C8C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(8, 8),
                      blurRadius: 15,
                      color: Color(0xffE549FE).withValues(alpha: 0.15),
                    ),
                  ]),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
            onPressed: () {},
          ),
        ),
        body: BlocConsumer<DutiesBloc, DutiesState>(
          listener: (context, state) {
            if (state is TasksCompleted) {
              int tabLength = state.tasksEntity.otherTasks!.isNotEmpty ? 2 : 1;
              _tabController = TabController(length: tabLength, vsync: this);
            }
          },
          buildWhen: (previous, current) {
            if (current is TasksCompleted ||
                current is TasksLoading ||
                current is TasksError) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is TasksCompleted) {
              return DefaultTabController(
                length: _tabController.length,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      // عنوان لیست وظایف و مشاهده تمام وظایف
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
                                  'همه وظایف',
                                  textColorInLight: Color(0xff861C8C),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // اگر وظایف دیگران داشت، نمایش داده شود
                      state.tasksEntity.otherTasks!.isNotEmpty
                          ? TabBar(
                              controller: _tabController,
                              indicatorColor: Color(0xff861C8C),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            DutiesScreen.tabIndexNotifire,
                                        builder: (context, value, child) {
                                          return NormalMedium(
                                            'وظایف من',
                                            textColorInLight: value == 0
                                                ? null
                                                : Color(0xff828282),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            DutiesScreen.tabIndexNotifire,
                                        builder: (context, value, child) {
                                          return NormalMedium(
                                            'وظایف دیگران',
                                            textColorInLight: value == 1
                                                ? null
                                                : Color(0xff828282),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      // لیست وظایف
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // لیست وظایف من
                            MyListTask(state: state, isAllDuties: false),

                            if (state.tasksEntity.otherTasks!.isNotEmpty)
                              // لیست وظایف دیگران
                              OtherListTask(state: state, isAllDuties: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is TasksError) {
              return Scaffold(
                body: Center(child: Text(state.textError)),
              );
            } else if (state is TasksLoading) {
              return LoadingWidget();
            } else {
              return Scaffold(
                body: Center(child: Text('data')),
              );
            }
          },
        ),
      ),
    );
  }
}

class OtherListTask extends StatelessWidget {
  final TasksCompleted state;
  final bool isAllDuties;
  const OtherListTask({
    super.key,
    required this.state,
    required this.isAllDuties,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          isAllDuties
              ? SizedBox(height: 24)
              : Container(
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
          state.tasksEntity.otherTasks!.isNotEmpty
              ? ListView.builder(
                  itemCount: state.tasksEntity.otherTasks?.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final data = state.tasksEntity.otherTasks![index];
                    return TaskItem(
                      title: data.title ?? '',
                      date: data.date ?? '',
                      tag: data.taskTags!,
                      flagTitle: data.priority?.title ?? '',
                      flagColor: int.parse(
                          data.priority!.color!.replaceAll("#", "0xff")),
                      isOthers: true,
                      onTap: () {},
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
                                        .withValues(alpha: 0.12),
                                    blurRadius: 2.4,
                                    offset: Offset(0, 1.2),
                                    spreadRadius: 1.2,
                                  ),
                                ],
                              ),
                            ),
                      imageUrl: data.user?.profileImage,
                      avatarName: data.user?.name ?? '',
                    );
                  },
                )
              : SizedBox(
                  height: context.screenHeight / 2,
                  child: Center(
                    child: NormalRegular(
                      'وظیفه ای تعریف نشده.',
                      textColorInLight: Color(0xffCAC4CF),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class MyListTask extends StatelessWidget {
  final TasksCompleted state;
  final bool isAllDuties;
  const MyListTask({
    super.key,
    required this.state,
    required this.isAllDuties,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          isAllDuties
              ? SizedBox(height: 24)
              : Container(
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
          state.tasksEntity.myTasks!.isNotEmpty
              ? ListView.builder(
                  itemCount: state.tasksEntity.myTasks?.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final data = state.tasksEntity.myTasks![index];
                    return TaskItem(
                      title: data.title ?? '',
                      date: data.date ?? '',
                      tag: data.taskTags!,
                      flagTitle: data.priority?.title ?? '',
                      flagColor: int.parse(
                          data.priority!.color!.replaceAll("#", "0xff")),
                      isOthers: false,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyTaskScreen(taskId: data.id!),
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
                                        .withValues(alpha: 0.12),
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
                )
              : SizedBox(
                  height: context.screenHeight / 2,
                  child: Center(
                    child: NormalRegular(
                      'وظیفه ای تعریف نشده.',
                      textColorInLight: Color(0xffCAC4CF),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isListTag;
  final List<TaskTag> tag;
  final String flagTitle;
  final int flagColor;
  final bool isOthers;
  final Widget icon;
  final String? imageUrl;
  final String? avatarName;
  final Function() onTap;
  const TaskItem({
    super.key,
    required this.title,
    required this.date,
    required this.tag,
    required this.flagTitle,
    required this.flagColor,
    required this.isOthers,
    required this.onTap,
    required this.isListTag,
    required this.icon,
    required this.imageUrl,
    required this.avatarName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 30,
              color: Color(0xff828282).withValues(alpha: 0.04),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                SizedBox(width: 8),
                NormalMedium(title),
                Spacer(),
                SmallRegular(date),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                tag.isNotEmpty
                    ? TagContainer(
                        color:
                            int.parse(tag.first.color!.replaceAll("#", "0xff")),
                        textColor: int.parse(
                            tag.first.textColor!.replaceAll("#", "0xff")),
                        isList: isListTag,
                        title: tag.first.title!,
                      )
                    : Container(),
                isOthers
                    ? Row(
                        children: [
                          tag.isNotEmpty ? SizedBox(width: 16) : Container(),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: imageUrl != null
                                ? Image.network(imageUrl!, height: 24)
                                : Assets.icons.avatar.svg(),
                          ),
                          SizedBox(width: 4),
                          SmallMedium(avatarName ?? ''),
                        ],
                      )
                    : Container(),
                Spacer(),
                PriorityWidget(colorFlag: flagColor, title: flagTitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TagContainer extends StatelessWidget {
  final int color;
  final String title;
  final int textColor;
  final bool isList;
  const TagContainer({
    super.key,
    required this.color,
    required this.isList,
    required this.textColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 79,
      height: 26,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: SmallRegular(
        title,
        textColorInLight: Color(textColor),
      ),
    );
  }
}
