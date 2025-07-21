import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/constants.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/progress_button.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

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
                    _showMap(),
                    VerticalSpace(50),
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
                              photo = await picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                photos.add(photo);
                              });
                            },
                          ),
                          ProgressButton(
                            width: context.screenWidth * .25,
                            height: 40,
                            isEnabled: photo != null && photos.isNotEmpty,
                            label: 'ارسال',
                            onTap: () {
                              setState(() {
                                bloc.add(SaveLocationEvent(
                                  position: _positions.isNotEmpty
                                      ? _positions.last
                                      : LatLng(
                                          AccessLocationScreen
                                                  .latitudeNotifire.value ??
                                              35.6892,
                                          AccessLocationScreen
                                                  .longitudeNotifire.value ??
                                              51.3890,
                                        ),
                                  // img: photos.isNotEmpty ? photos : null,
                                ));
                                photo = null;
                                photos.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    VerticalSpace(40),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        if (photo == null) return SizedBox();
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photo.path),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: SmallMedium(
                            'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ',
                          ),
                        );
                      },
                    ),
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
          width: context.screenWidth * 0.9,
          height: context.screenHeight * 0.45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _positions.isNotEmpty
                    ? _positions.last
                    : LatLng(
                        AccessLocationScreen.latitudeNotifire.value ?? 35.6892,
                        AccessLocationScreen.longitudeNotifire.value ?? 51.3890,
                      ),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.neshan.org/v2/static?key=${Constants.API_KY_MAP}&type=neshan&zoom=15&center=${AccessLocationScreen.latitudeNotifire.value},${AccessLocationScreen.longitudeNotifire.value}&width=500&height=500&marker=red',
                  // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.linchpinx.app.linchpinx',
                ),
                MarkerLayer(
                  markers: _positions
                      .asMap()
                      .entries
                      .map(
                        (entry) => Marker(
                          point: entry.value,
                          width: 40,
                          height: 50,
                          child: Column(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.red, size: 30),
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
