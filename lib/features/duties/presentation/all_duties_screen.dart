import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/loading_widget.dart';
import 'package:linchpin_app/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin_app/features/duties/presentation/duties_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class AllDutiesScreen extends StatefulWidget {
  const AllDutiesScreen({super.key});

  @override
  State<AllDutiesScreen> createState() => _AllDutiesScreenState();
  static late ValueNotifier<int> tabIndexNotifire;
}

class _AllDutiesScreenState extends State<AllDutiesScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AllDutiesScreen.tabIndexNotifire = ValueNotifier(0);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      AllDutiesScreen.tabIndexNotifire.value = _tabController.index;
    });
    BlocProvider.of<DutiesBloc>(context).add(AllTasksEvent());
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AllDutiesScreen.tabIndexNotifire.dispose();
    _tabController.dispose();
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
      appBar: appBarRoot(context, true),
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
      body: BlocBuilder<DutiesBloc, DutiesState>(
        builder: (context, state) {
          if (state is AllTasksCompleted) {
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
                    state.tasksEntity.otherTasks!.isNotEmpty
                        ? TabBar(
                            controller: _tabController, // اضافه کردن کنترلر
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
                                          AllDutiesScreen.tabIndexNotifire,
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
                                          AllDutiesScreen.tabIndexNotifire,
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
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MyListTask(state: state, isAllDuties: true),
                          OtherListTask(state: state, isAllDuties: true),
                        ],
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
