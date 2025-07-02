import 'dart:io';

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
import 'package:linchpin/features/visitor/domain/entity/visitor_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_image.dart';
import 'package:linchpin/main.dart' hide LocationService;

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
  List<VisitorEntity>? visitors = [];
  LatLng? lat;
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
      lat = LatLng(35.6892, 51.3860);
      // final lat = LatLng(position.latitude, position.longitude);
      mapController.move(lat ?? LatLng(35.6892, 51.3890), 16);
      _positions.add(lat ?? LatLng(35.6892, 51.3890));
      // mapController.move(mapCenter, 16);
      // _positions.add(mapCenter); // اضافه کردن موقعیت جدید به لیست
    });
  }

  //! نمایش پیام خطا
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    bloc = getIt<VisitorBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<VisitorBloc, VisitorState>(
        listener: (context, state) {
          if (state is SaveLocationSuccess) {
            visitors = bloc.visitors;
          }
          if (state is SaveLocationFailure) {
            _showSnackbar(state.error ?? 'خطا رخ داد');
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _showMap(),
                    VerticalSpace(50),
                    buttons(state),
                    VerticalSpace(20),
                    ShowImage(photos: photos),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

//! دکمه های پایین نقشه
  Row buttons(VisitorState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProgressButton(
          width: 130,
          height: 40,
          label: 'ثبت موقعیت',
          onTap: _getLocationAndShowMarker,
          isLoading: state is SaveLocationLoading,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        ProgressButton(
          width: 130,
          height: 40,
          label: bloc.photo == null ? 'گرفتن عکس' : 'اضافه کردن عکس',
          isEnabled: lat != null,
          isLoading: state is SaveLocationLoading,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
          onTap: () async {
            bloc.isDeleted = true;
            bloc.photo = await picker.pickImage(source: ImageSource.camera);
            setState(() {
              if (bloc.photo != null) {
                bloc.capturedImages.add(File(bloc.photo!.path));
                photos.add(bloc.photo);
              }
            });
          },
        ),
        ProgressButton(
          width: 130,
          height: 40,
          isEnabled: bloc.photo != null && photos.isNotEmpty,
          isLoading: state is SaveLocationLoading,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
          label: 'ارسال',
          onTap: () {
            setState(() {
              bloc.isDeleted = false;
              bloc.photo = null;
              lat = null;
              // for (var image in bloc.capturedImages) {
              //   String fileName = image.path;

              //   bloc.multipartImages.add(
              //     await MultipartFile.fromFile(
              //       image.path,
              //       filename: fileName,
              //       // contentType: MediaType("image", "jpeg"),
              //     ),
              //   );
              //   bloc.formData = FormData.fromMap({
              //     'photos':
              //         bloc.multipartImages, // ← مطابق با کلید مورد انتظار سرور
              //   });
              // }
              if (bloc.capturedImages.isNotEmpty) {
                bloc.add(SaveLocationEvent(
                  position: _positions.isNotEmpty
                      ? _positions.last
                      : LatLng(35.6892, 51.3890),
                  img: bloc.formData,
                ));
              }
            });
          },
        ),
      ],
    );
  }

  //!  نمایش نقشه و دکمه
  Widget _showMap() {
    return Stack(
      children: [
        _map(),
        _iconMap(),
      ],
    );
  }

  //! نقشه
  Widget _map() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.screenWidth * 0.95,
          height: context.screenHeight * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _positions.isNotEmpty
                    ? _positions.last
                    : LatLng(35.6892, 51.3890),
                // zoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _positions
                      .asMap()
                      .entries
                      .map(
                        (entry) => Marker(
                          point: entry.value,
                          width: 40,
                          height: 40,
                          child: Column(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.red, size: 36),
                              Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

//! دکمه روی نقشه
  Widget _iconMap() {
    return Positioned(
      bottom: 5,
      right: 10,
      child: IconButton(
        onPressed: () {
          mapController.move(
            LatLng(
              double.parse(
                '36.29608',
              ),
              double.parse(
                '59.57204',
              ),
            ),
            16.5,
          );
        },
        icon: const Icon(
          Icons.my_location_rounded,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );
  }
}
