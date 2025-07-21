import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/duties/presentation/duties_screen.dart';
import 'package:linchpin/features/growth/data/models/user_improvement_model/item.dart';
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart';
import 'package:linchpin/features/growth/presentation/sub_items_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<GrowthBloc>(context).add(UserImprovementEvent());
    _controller.text = '';

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.clear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  void showReportModal(BuildContext context, Item data) {
    if (data.done!) return;
    if (data.type == 'INTELLIGENSE') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubItemsScreen(
            title: data.title!,
            itemId: data.id!,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // to full height
        useSafeArea: true, // to show under status bar
        backgroundColor:
            Colors.transparent, // to show BorderRadius of Container
        sheetAnimationStyle: AnimationStyle(
          reverseCurve: Curves.easeIn,
          duration: Duration(milliseconds: 400),
        ),
        builder: (context) {
          return IOSModalStyle(
            childBody: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 23,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color(0xff000000).withValues(alpha: .15),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  LargeBold(
                    'میزان محبوبیت:',
                    textColorInLight: Color(0xff333333),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(data.score!.length, (index) {
                        final score = data.score![index];
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<GrowthBloc>(context)
                                .add(SubitemsScoreEvent(
                              data.id!,
                              data.id!,
                              score,
                            ));
                          },
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xffE0E0F9)),
                            ),
                            alignment: Alignment.center,
                            child: VeryBigBold('$score'),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Color withOpacityNew(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocBuilder<GrowthBloc, GrowthState>(
        buildWhen: (previous, current) {
          if (current is UserImprovementCompletedState ||
              current is UserImprovementLoadingState ||
              current is UserImprovementErrorState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is UserImprovementCompletedState) {
            bool isEnglish =
                EasyLocalization.of(context)?.locale.languageCode == 'en';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstGrowthWidget(state: state),
                    ListView.builder(
                      itemCount: state.userImprovementEntity.userItems!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context, groupIndex) {
                        final group =
                            state.userImprovementEntity.userItems![groupIndex];
                        final color = int.parse(
                            group.items!.first.color!.replaceAll("#", "0xff"));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...group.items!.map((item) {
                              return GestureDetector(
                                onTap: () => showReportModal(context, item),
                                child: Container(
                                  height: 72,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                            begin: isEnglish
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            end: isEnglish
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            colors: [
                                              item.done!
                                                  ? withOpacityNew(
                                                      Colors.black, 0.2)
                                                  : withOpacityNew(
                                                      Color(color), 0.2),
                                              item.done!
                                                  ? withOpacityNew(
                                                      Colors.black, 0.8)
                                                  : withOpacityNew(
                                                      Color(color), 0.8),
                                            ],
                                          ),
                                        ),
                                        child: item.image!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: item.image!,
                                                fit: BoxFit.cover,
                                              )
                                            : SizedBox(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            item.done!
                                                ? Assets.icons.check.svg(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(width: 4),
                                            NormalDemiBold(item.title!,
                                                textColorInLight: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            if (groupIndex <
                                state.userImprovementEntity.userItems!.length -
                                    1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserImprovementLoadingState) {
            return LoadingWidget();
          } else if (state is UserImprovementErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<GrowthBloc>(context)
                    .add(UserImprovementEvent());
              },
            );
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      )),
    );
  }
}

class RequestGrowthWidget extends StatelessWidget {
  final void Function(Item updatedItem) onReportSuccess;
  const RequestGrowthWidget({
    super.key,
    required TextEditingController controller,
    required this.data,
    required this.onReportSuccess,
  }) : _controller = controller;

  final TextEditingController _controller;
  final Item data;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrowthBloc, GrowthState>(
      listener: (context, state) {
        if (state is UserSelfAddCompletedState) {
          final updatedItem = Item(
            id: data.id,
            title: data.title,
            color: data.color,
            image: data.image,
            done: true,
          );
          onReportSuccess(updatedItem);
          Navigator.pop(context);
        }
      },
      buildWhen: (previous, current) {
        if (current is UserSelfAddCompletedState ||
            current is UserSelfAddLoadingState ||
            current is UserSelfAddErrorState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (_controller.text.isNotEmpty) {
              BlocProvider.of<GrowthBloc>(context).add(
                UserSelfAddEvent(
                  improvementId: data.id!,
                  description: _controller.text,
                ),
              );
            }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xff861C8C),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: state is UserSelfAddLoadingState
                ? CupertinoActivityIndicator(color: Colors.white)
                : NormalDemiBold(
                    LocaleKeys.activityReport.tr(),
                    textColorInLight: Colors.white,
                  ),
          ),
        );
      },
    );
  }
}

class ConstGrowthWidget extends StatefulWidget {
  final UserImprovementCompletedState state;
  const ConstGrowthWidget({super.key, required this.state});

  @override
  State<ConstGrowthWidget> createState() => _ConstGrowthWidgetState();
}

class _ConstGrowthWidgetState extends State<ConstGrowthWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            BigDemiBold(LocaleKeys.individualGrowth.tr()),
            Spacer(),
            SvgPicture.network(
              widget.state.userImprovementEntity.scoreIcon!,
              placeholderBuilder: (context) =>
                  SizedBox(height: 24, child: CupertinoActivityIndicator()),
            ),
            SizedBox(width: 4),
            NormalMedium(
                '${widget.state.userImprovementEntity.score} ${LocaleKeys.score.tr()}'),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: TodayTagWidget(),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
