import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/loading_widget.dart';
import 'package:linchpin_app/features/duties/data/models/tasks_model/task_tag.dart';
import 'package:linchpin_app/features/duties/presentation/all_duties_screen.dart';
import 'package:linchpin_app/features/duties/presentation/bloc/duties_bloc.dart';
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
      DutiesScreen.tabIndexNotifire.value = _tabController.index;
    });
    BlocProvider.of<DutiesBloc>(context).add(TasksEvent(
      startDate: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
      endDate: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
    ));
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
      body: BlocBuilder<DutiesBloc, DutiesState>(
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
                                    state.tasksEntity.myTasks?.length
                                            .toString() ??
                                        '0',
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
                                    state.tasksEntity.otherTasks?.length
                                            .toString() ??
                                        '0',
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
                                                        .withValues(
                                                            alpha: 0.12),
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
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isListTag;
  final List<TaskTag> tag;
  final String flagTitle;
  final Widget imageFlag;
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
    required this.imageFlag,
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
                        tag: tag,
                        color: Color(0xffB10000),
                        isList: isListTag,
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
  final bool isList;
  const TagContainer({
    super.key,
    required this.tag,
    required this.color,
    required this.isList,
  });

  final List<TaskTag> tag;

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
        tag.first.title!,
        textColorInLight: color,
      ),
    );
  }
}
