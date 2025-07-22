import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/progress_button.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_image.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_map.dart';
import 'package:linchpin/features/visitor/presentation/widgets/text_field.dart';

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
  Position? position;
  List<XFile?> photos = [];
  final List<LatLng> _positions = []; // لیست موقعیت‌ها
  final mapCenter = LatLng(
      AccessLocationScreen.latitudeNotifire.value ?? 35.6892,
      AccessLocationScreen.longitudeNotifire.value ?? 51.3890);
  Future<void> _getLocationAndShowMarker() async {
    LocationService locationService = LocationService();
    position = await locationService.getUserLocation();
    if (!mounted) return;
    if (position == null) {
      isLoadingNotifire.value = false;
      _showSnackbar("خطا در دریافت موقعیت مکانی یا دسترسی رد شده است.");
      return;
    }
    setState(() {
      // final lat = LatLng(35.6892, 51.3890);
      final lat =
          LatLng(position?.latitude ?? 35.6892, position?.longitude ?? 51.3890);
      mapController.move(lat, 16);
      _positions.add(lat);
      // mapController.move(mapCenter, 16);
      // _positions.add(mapCenter); // اضافه کردن موقعیت جدید به لیست
    });
  }

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
          isNear(bloc.currentLocation!, target)) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  @override
  void initState() {
    bloc = getIt<VisitorBloc>();
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
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ShowMap(
                      context: context,
                      mapController: mapController,
                      positions: _positions,
                    ),
                    VerticalSpace(25),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProgressButton(
                            width: context.screenWidth * .34,
                            height: 40,
                            label: 'ثبت موقعیت',
                            onTap: _getLocationAndShowMarker,
                          ),
                          ProgressButton(
                            width: context.screenWidth * .34,
                            height: 40,
                            label:
                                photos.isEmpty ? 'گرفتن عکس' : 'اضافه کردن عکس',
                            onTap: () async {
                              if (!isEnableSendButton()) {
                                photo = await picker.pickImage(
                                    source: ImageSource.camera);
                                setState(() {
                                  photos.add(photo);
                                });
                              } else {
                                _showSnackbar('موقعیت غیر مجاز');
                              }
                            },
                          ),
                          ProgressButton(
                            width: context.screenWidth * .25,
                            height: 40,
                            isEnabled: photo != null &&
                                photos.isNotEmpty &&
                                isEnableSendButton(),
                            label: 'ارسال',
                            onTap: () async {
                              if (isEnableSendButton()) {
                                List<MultipartFile> imageFiles = [];
                                for (var photo in photos) {
                                  if (photo != null) {
                                    imageFiles.add(
                                      await MultipartFile.fromFile(
                                        photo.path,
                                        filename: photo.name,
                                      ),
                                    );
                                  }
                                }
                                final formData = FormData.fromMap({
                                  "images":
                                      imageFiles, // این اسم باید با انتظارات سرور هماهنگ باشه
                                  // می‌تونی سایر فیلدها رو هم اضافه کنی
                                  "user_id": "123",
                                });
                                setState(() {
                                  bloc.add(SaveLocationEvent(
                                    position: LatLng(
                                      AccessLocationScreen
                                              .latitudeNotifire.value ??
                                          35.6892,
                                      AccessLocationScreen
                                              .longitudeNotifire.value ??
                                          51.3890,
                                    ),
                                    img: formData,
                                  ));
                                  photo = null;
                                  photos.clear();
                                });
                                // ثبت در دیتابیس یا تغییر UI
                              } else {
                                _showSnackbar('محدوه غیر مجاز');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    VerticalSpace(40),
                    ShowImage(photos: photos),
                    VerticalSpace(20),
                    TextFieldWedget(photos: photos),
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
}
