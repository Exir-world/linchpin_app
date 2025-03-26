import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin/features/duties/presentation/duties_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class AllDutiesScreen extends StatefulWidget {
  const AllDutiesScreen({super.key});

  @override
  State<AllDutiesScreen> createState() => _AllDutiesScreenState();
  static late ValueNotifier<int> tabIndexNotifire;
}

class _AllDutiesScreenState extends State<AllDutiesScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabControllerOne;
  late TabController _tabControllerTwo;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AllDutiesScreen.tabIndexNotifire = ValueNotifier(0);
    _tabControllerOne = TabController(length: 1, vsync: this);
    _tabControllerTwo = TabController(length: 2, vsync: this);
    // استفاده از addPostFrameCallback که باعث میشه کد بعد از رندر شدن صفحه اجرا بشه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabControllerOne.addListener(() {
        AllDutiesScreen.tabIndexNotifire.value = _tabControllerOne.index;
      });
      _tabControllerTwo.addListener(() {
        AllDutiesScreen.tabIndexNotifire.value = _tabControllerTwo.index;
      });
    });

    BlocProvider.of<DutiesBloc>(context).add(AllTasksEvent());
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AllDutiesScreen.tabIndexNotifire.dispose();
    _tabControllerOne.dispose();
    _tabControllerTwo.dispose();
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
        true,
        () => Navigator.pop(context),
      ),
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
          if (state is AllTasksCompleted) {
            if (state.tasksEntity.otherTasks!.isNotEmpty) {
              _tabControllerTwo = TabController(length: 2, vsync: this);
            } else {
              _tabControllerOne = TabController(length: 1, vsync: this);
            }
          }
        },
        builder: (context, state) {
          if (state is AllTasksCompleted) {
            return DefaultTabController(
              length: state.tasksEntity.otherTasks!.isNotEmpty
                  ? _tabControllerTwo.length
                  : _tabControllerOne.length,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BigDemiBold(LocaleKeys.taskList.tr()),
                        Spacer(),
                        Row(
                          children: [
                            Assets.icons.filter.svg(),
                            SizedBox(width: 8),
                            NormalMedium(
                              LocaleKeys.filtering.tr(),
                              textColorInLight: Color(0xff861C8C),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    state.tasksEntity.otherTasks!.isNotEmpty
                        ? TabBar(
                            controller: _tabControllerTwo, // اضافه کردن کنترلر
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
                                          LocaleKeys.myTasks.tr(),
                                          textColorInLight: value == 0
                                              ? null
                                              : Color(0xff828282),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (state.tasksEntity.otherTasks!.isNotEmpty)
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
                                            LocaleKeys.othersTasks.tr(),
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
                        controller: state.tasksEntity.otherTasks!.isNotEmpty
                            ? _tabControllerTwo
                            : _tabControllerOne,
                        children: [
                          MyListTask(state: state, isAllDuties: true),
                          if (state.tasksEntity.otherTasks!.isNotEmpty)
                            OtherListTask(state: state, isAllDuties: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AllTasksError) {
            return ErrorUiWidget(
              title: state.textError,
              onTap: () {
                BlocProvider.of<DutiesBloc>(context).add(AllTasksEvent());
              },
            );
          } else if (state is AllTasksLoading) {
            return LoadingWidget();
          } else {
            return Scaffold(
              body: Center(child: NormalMedium('data')),
            );
          }
        },
      ),
    );
  }
}
