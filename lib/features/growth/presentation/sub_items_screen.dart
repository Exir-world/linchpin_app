import 'package:calendar_pro_farhad/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class SubItemsScreen extends StatefulWidget {
  final String title;
  final int itemId;
  const SubItemsScreen({super.key, required this.title, required this.itemId});

  @override
  State<SubItemsScreen> createState() => _SubItemsScreenState();
}

class _SubItemsScreenState extends State<SubItemsScreen> {
  @override
  void initState() {
    BlocProvider.of<GrowthBloc>(context).add(SubitemsEvent(widget.itemId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(
        context,
        true,
        () => Navigator.pop(context),
      ),
      body: BlocBuilder<GrowthBloc, GrowthState>(
        buildWhen: (previous, current) {
          if (current is SubitemsCompletedState ||
              current is SubitemsLoadingState ||
              current is SubitemsErrorState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is SubitemsCompletedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    BigDemiBold(
                      widget.title,
                      textColorInLight: Color(0xff540E5C),
                    ),
                    SizedBox(height: 24),
                    ListView.builder(
                      itemCount: state.subItemsEntity.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = state.subItemsEntity[index];
                        return GestureDetector(
                          onTap: data.done!
                              ? () {}
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // to full height
                                    useSafeArea:
                                        true, // to show under status bar
                                    backgroundColor: Colors
                                        .transparent, // to show BorderRadius of Container
                                    sheetAnimationStyle: AnimationStyle(
                                      reverseCurve: Curves.easeIn,
                                      duration: Duration(milliseconds: 400),
                                    ),
                                    builder: (context) {
                                      return IOSModalStyle(
                                        childBody: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 23,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: Color(0xff000000)
                                                        .withValues(alpha: .15),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 32),
                                              LargeBold(
                                                'میزان محبوبیت:',
                                                textColorInLight:
                                                    Color(0xff333333),
                                              ),
                                              SizedBox(height: 24),
                                              SizedBox(
                                                height: 80,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: List.generate(
                                                      data.score!.length,
                                                      (index) {
                                                    final score =
                                                        data.score![index];
                                                    return Container(
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffE0E0F9)),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          VeryBigBold('$score'),
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
                                },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NormalRegular('${data.title}'),
                                data.done!
                                    ? Assets.icons.calendar.svg()
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is SubitemsLoadingState) {
            return LoadingWidget();
          } else if (state is SubitemsErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<GrowthBloc>(context).add(UserSelfEvent());
              },
            );
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      ),
    );
  }
}
