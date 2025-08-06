import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/constants.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart'
    hide Attachments;
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/domain/entity/upload_image_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:linchpin/features/visitor/presentation/widgets/selected_location.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_map.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_text.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  ValueNotifier<bool> isLoadingNotifire = ValueNotifier(false);
  final mapController = MapController();
  final ImagePicker picker = ImagePicker();
  late VisitorBloc bloc;
  XFile? photo;
  Map<String, String> result = {};
  List<XFile?> photos = [];
  Position? position;
  final List<LatLng> _positions = []; // لیست موقعیت‌ها
  List<CurrentLocationEntity>? options = [];
  List<Items> items = [];
  List<UploadImageEntity> uploadImage = [];
  // List<Attachments>? attachments = [];
  final mapCenter = LatLng(
      AccessLocationScreen.latitudeNotifire.value ?? 35.6892,
      AccessLocationScreen.longitudeNotifire.value ?? 51.3890);

//! محدوده مجاز
  bool isNear(LatLng current, LatLng target) {
    final distance = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      target.latitude,
      target.longitude,
    );
    return distance < 50; // متر
  }

  //! نمایش پیام خطا
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool isEnableSendButton() {
    bool result = false;
    for (final target in bloc.visitTargets) {
      if (bloc.currentLocation != null &&
          isNear(bloc.currentLocation!, target.latLng ?? LatLng(0.0, 0.0))) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

//! گرفتن آدرس از نشان
  Future<void> _getAddress(double lat, double lng) async {
    final url =
        Uri.parse('https://api.neshan.org/v5/reverse?lat=$lat&lng=$lng');

    try {
      final response = await http.get(
        url,
        headers: {
          "Api-Key": Constants.API_KY_MAP,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bloc.address.sink.add(data['formatted_address'] ?? 'آدرس یافت نشد');
      } else {
        bloc.address.sink.add("خطا در دریافت آدرس");
      }
    } catch (e) {
      bloc.address.sink.add("خطا: $e");
    }
  }

  @override
  void initState() {
    bloc = getIt<VisitorBloc>()..add(GetLocation());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<VisitorBloc, VisitorState>(
        listener: (context, state) async {
          if (state is GetLocationSuccess) {
            items = bloc.items;
            for (var element in items) {
              var isOk = await bloc.isLatLngInMap(
                double.parse(element.lat.toString()),
                double.parse(
                  element.lng.toString(),
                ),
              );
              if (isOk) {
                result = await bloc.loadLatLngMap();
              } else {
                await _getAddress(
                  double.parse(element.lat.toString()),
                  double.parse(
                    element.lng.toString(),
                  ),
                );
                Map<String, String> oldMap = await bloc.loadLatLngMap();
                oldMap['${element.lat},${element.lng}'] =
                    bloc.address.value ?? '';
                await bloc.saveLatLngMap(oldMap);
              }
              result = await bloc.loadLatLngMap();
              // address = result.entries.map((entry) => entry.value).toList();
              try {
                bloc.list_address = result.entries.map((entry) {
                  if (entry.value.contains('خطا')) {
                    return LocaleKeys.noaddressfound.tr();
                  } else {
                    return entry.value;
                  }
                }).toList();
              } catch (e) {
                bloc.list_address = [LocaleKeys.noaddressfound.tr()];
              }
            }
            options?.clear();
            for (var i = 0; i < bloc.visitTargets.length; i++) {
              final element = bloc.visitTargets[i];
              final name = i < bloc.list_address.length
                  ? bloc.list_address[i]
                  : 'آدرس مشخص نشده';
              options?.add(
                CurrentLocationEntity(
                  lat: element.lat.toString(),
                  lng: element.lng.toString(),
                  name: '${i + 1} - $name',
                  id: element.id,
                ),
              );
            }
          }
          if (state is SetLocationSuccess) {
            bloc.add(GetLocation());
            bloc.selectedValue.value.name = null;
            _showSnackbar('عملیات با موفقیت انجام شد.');
          }
          bloc.attachments?.clear();
          if (state is UploadImageSuccess) {
            uploadImage = bloc.uploadImage;
            for (var element in uploadImage) {
              bloc.attachments?.add(Attachments(
                fileUrl: element.url,
                filename: element.originalName,
              ));
            }
            bloc.add(
              SetLocationEvent(
                setLocationRequest: SetLocationRequest(
                  attachments: bloc.attachments,
                  checkPointId: bloc.current_Location?.id ?? 0,
                  lat: AccessLocationScreen.latitudeNotifire.value,
                  lng: AccessLocationScreen.longitudeNotifire.value,
                  report: bloc.desc.value,
                ),
              ),
            );
            bloc.desc.value = null;
          }
          if (state is ErrorData) {
            ErrorUiWidget(
              title: state.error ?? '',
              onTap: () {
                BlocProvider.of<VisitorBloc>(context).add(GetLocation());
              },
            );
          }
        },
        builder: (context, state) {
          return state is ErrorData
              ? ErrorUiWidget(
                  title: state.error ?? '',
                  onTap: () {
                    BlocProvider.of<VisitorBloc>(context).add(GetLocation());
                  },
                )
              : Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //! نمایش نقشه
                          ShowMap(
                            context: context,
                            mapController: mapController,
                            positions: _positions,
                          ),
                          VerticalSpace(25),
                          //! انتخاب موقعیت
                          SelectedLocations(
                            options: options ?? [],
                            mapController: mapController,
                            bloc: bloc,
                          ),
                          VerticalSpace(15),
                          //! موقعیت های بازدید شده
                          placesSeen(),
                          VerticalSpace(20),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

//! موقعیت های بازدید شده
  ListView placesSeen() {
    return ListView.builder(
      itemCount: items.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final data = items[index];
        return data.userCheckPoints?.attachments != null
            ? Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 30,
                      offset: Offset(0, 3),
                      color: Color(0xff828282).withValues(alpha: .05),
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    showModal(context, data, bloc.list_address[index]);
                  },
                  subtitle: SmallRegular(
                    bloc.list_address[index],
                    textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR,
                  ),
                  title: SmallBold(
                    data.userCheckPoints?.createdAt?.toPersianDate() ?? '',
                    textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: data.userCheckPoints!.attachments!.isNotEmpty
                          ? data.userCheckPoints!.attachments!.first.fileUrl ??
                              ''
                          : '',
                      width: 60,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.broken_image,
                        size: 60,
                      ),
                    ),
                  ),
                ))
            : EmptyContainer();
      },
    );
  }

//! جزئیات موقعیت بازدید شده
  Future<dynamic> showModal(
      BuildContext context, Items data, String locationName) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return SizedBox(
          height: context.screenHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                VerticalSpace(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        photo = null;
                        photos.clear();
                      },
                      icon: const Icon(Icons.close, size: 28),
                    ),
                  ],
                ),
                ShowText(
                    text: SmallRegular(
                  locationName,
                  textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR,
                )),
                if (data.userCheckPoints?.report?.isNotEmpty ?? false)
                  ShowText(
                      text: SmallRegular(
                    data.userCheckPoints!.report!,
                    textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR,
                  )),
                VerticalSpace(10),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: data.userCheckPoints?.attachments?.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // سه ستون
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final element = data.userCheckPoints!.attachments![index];
                      return GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: context.screenHeight,
                                width: context.screenWidth,
                                child: InteractiveViewer(
                                  panEnabled: true,
                                  minScale: 1,
                                  maxScale: 4,
                                  child: CachedNetworkImage(
                                    imageUrl: element.fileUrl ?? '',
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.fill,
                            imageUrl: element.fileUrl ?? '',
                            placeholder: (context, url) =>
                                CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.broken_image,
                              size: 40,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                VerticalSpace(20),
              ],
            ),
          ),
        );
      },
    );
  }
}
