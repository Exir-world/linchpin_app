import 'package:Linchpin/core/common/text_widgets.dart';
import 'package:Linchpin/core/customui/loading_widget.dart';
import 'package:Linchpin/core/extension/context_extension.dart';
import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:Linchpin/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:Linchpin/features/root/presentation/app_bar_root.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shamsi_date/shamsi_date.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationsBloc _bloc;
  late NotificationsEntity _localNotifications;
  @override
  void initState() {
    _bloc = getIt<NotificationsBloc>();
    _bloc.add(NotificationListEvent());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationListCompletedState) {
            setState(() {
              _localNotifications = state.notificationsEntity;
            });
          }
        },
        builder: (context, state) {
          if (state is NotificationListCompletedState) {
            return Scaffold(
              appBar: appBarRoot(context, true),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      // TitleScreen(
                      //   title: 'اعلانات',
                      //   icon: Assets.icons.notificationS.svg(),
                      //   desc: 'همه اعلان ها',
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => AllNotificationsScreen(),
                      //         ));
                      //   },
                      // ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: BigDemiBold('اعلانات')),
                      SizedBox(height: 8),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     width: 50,
                      //     margin: EdgeInsets.only(top: 24, bottom: 16),
                      //     decoration: BoxDecoration(
                      //       color: Color(0xffF5EEFC),
                      //       borderRadius: BorderRadius.circular(37),
                      //     ),
                      //     alignment: Alignment.center,
                      //     padding: EdgeInsets.symmetric(vertical: 5),
                      //     child: SmallRegular('امروز'),
                      //   ),
                      // ),
                      // SizedBox(height: 8),
                      _localNotifications.notifications!.isNotEmpty
                          ? ListView.builder(
                              itemCount: state
                                  .notificationsEntity.notifications?.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = state
                                    .notificationsEntity.notifications![index];
                                final color = int.parse(data.typeStyles!.color!
                                    .replaceAll("#", "0xff"));
                                final date = data.createdAt!.toJalali();
                                return ItemNotifList(
                                  color: Color(color),
                                  isread: data.read!,
                                  title: data.title!,
                                  desc: data.description!,
                                  date:
                                      '${date.year}/${date.month}/${date.day}',
                                  onTap: () {},
                                  icon: CachedNetworkImage(
                                    imageUrl: data.typeStyles!.icon!,
                                  ),
                                );
                              },
                            )
                          : SizedBox(
                              height: context.screenHeight / 2,
                              child: Center(
                                child: NormalRegular(
                                  'اعلان جدیدی ندارید.',
                                  textColorInLight: Color(0xffCAC4CF),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is NotificationListLoadingState) {
            return LoadingWidget();
          } else if (state is NotificationListErrorState) {
            return Center(child: Text(state.errorText));
          } else {
            return Center(child: Text("data"));
          }
        },
      ),
    );
  }
}

class TitleScreen extends StatelessWidget {
  final String title;
  final Widget icon;
  final String desc;
  final Function() onTap;
  const TitleScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigDemiBold(title),
          Row(
            children: [
              icon,
              SizedBox(width: 8),
              NormalMedium(
                desc,
                textColorInLight: Color(0xff861C8C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemNotifList extends StatelessWidget {
  final Color color;
  final bool isread;
  final String title;
  final String desc;
  final String date;
  final Function() onTap;
  final Widget icon;
  const ItemNotifList({
    super.key,
    required this.color,
    required this.isread,
    required this.title,
    required this.desc,
    required this.date,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 84,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xff828282).withValues(alpha: 0.04),
              offset: Offset(0, 3),
              blurRadius: 30,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: icon,
                ),
                !isread
                    ? Positioned(
                        top: -3,
                        right: -3,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalMedium(title),
                SizedBox(
                  width: context.screenWidth / 1.9,
                  child: NormalRegular(
                    desc,
                    textColorInLight: Color(0xff88719B),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                !isread
                    ? SmallRegular(
                        'جدید',
                        textColorInLight: Color(0xff00AA1F),
                      )
                    : SizedBox(),
                SmallRegular(
                  date,
                  textColorInLight: Color(0xff88719B),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
