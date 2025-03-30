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
import 'package:linchpin/features/growth/data/models/user_self_model/user_item.dart';
import 'package:linchpin/features/growth/presentation/bloc/growth_bloc.dart';
import 'package:linchpin/features/growth/presentation/sub_items_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:linchpin/gen/fonts.gen.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen>
    with WidgetsBindingObserver {
  List<UserItem>? _userItems;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<GrowthBloc>(context).add(UserSelfEvent());
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

  void showReportModal(BuildContext context, UserItem data) {
    if (data.done!) {
      return;
    } else if (data.type == 'IMPROVMENT' || data.type == 'FORBIDDEN') {
      _controller.text = '';
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        sheetAnimationStyle: AnimationStyle(
          reverseCurve: Curves.easeIn,
          duration: Duration(milliseconds: 400),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: IOSModalStyle(
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
                          color: Color(0xff000000).withOpacity(0.15),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    LargeBold(LocaleKeys.activityReport.tr()),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xffE0E0F9),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 5,
                        minLines: 5,
                        style: TextStyle(
                          fontFamily: FontFamily.iRANSansXFARegular,
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xffE0E0F9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xff861C8C),
                              width: 1,
                            ),
                          ),
                          isCollapsed: true,
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 72),
                    RequestGrowthWidget(
                      controller: _controller,
                      data: data,
                      onReportSuccess: (UserItem updatedItem) {
                        setState(() {
                          final index = _userItems!.indexWhere(
                            (element) => element.id == updatedItem.id,
                          );
                          if (index != -1) {
                            _userItems![index] = updatedItem;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (data.type == 'INTELLIGENSE') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubItemsScreen(
              title: data.title!,
              itemId: data.id!,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocBuilder<GrowthBloc, GrowthState>(
        buildWhen: (previous, current) {
          if (current is UserSelfCompletedState ||
              current is UserSelfLoadingState ||
              current is UserSelfErrorState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is UserSelfCompletedState) {
            _userItems = state.userSelfEntity.userItems;
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
                      itemCount: state.userSelfEntity.userItems!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context, index) {
                        final data = state.userSelfEntity.userItems![index];
                        final color =
                            int.parse(data.color!.replaceAll("#", "0xff"));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => showReportModal(context, data),
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
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: isEnglish
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          end: isEnglish
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          colors: [
                                            data.done!
                                                ? Colors.black.withOpacity(0.2)
                                                : Color(color).withOpacity(0.2),
                                            data.done!
                                                ? Colors.black.withOpacity(0.8)
                                                : Color(color).withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      child: data.image!.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: data.image!,
                                              fit: BoxFit.cover,
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        children: [
                                          data.done!
                                              ? Assets.icons.check
                                                  .svg(color: Colors.white)
                                              : SizedBox(),
                                          SizedBox(width: 4),
                                          NormalDemiBold(
                                            data.title!,
                                            textColorInLight: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Divider برای جدا کردن گروه‌ها
                            if (index <
                                    state.userSelfEntity.userItems!.length -
                                        1 &&
                                state.userSelfEntity.userItems![index + 1]
                                        .type !=
                                    data.type)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserSelfLoadingState) {
            return LoadingWidget();
          } else if (state is UserSelfErrorState) {
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
      )),
    );
  }
}

class RequestGrowthWidget extends StatelessWidget {
  final void Function(UserItem updatedItem) onReportSuccess;
  const RequestGrowthWidget({
    super.key,
    required TextEditingController controller,
    required this.data,
    required this.onReportSuccess,
  }) : _controller = controller;

  final TextEditingController _controller;
  final UserItem data;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrowthBloc, GrowthState>(
      listener: (context, state) {
        if (state is UserSelfAddCompletedState) {
          final updatedItem = UserItem(
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
  final UserSelfCompletedState state;
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
              widget.state.userSelfEntity.scoreIcon!,
              placeholderBuilder: (context) =>
                  SizedBox(height: 24, child: CupertinoActivityIndicator()),
            ),
            SizedBox(width: 4),
            NormalMedium(
                '${widget.state.userSelfEntity.score} ${LocaleKeys.score.tr()}'),
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
