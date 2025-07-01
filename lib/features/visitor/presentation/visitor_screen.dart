import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:image_picker/image_picker.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  final mapController = MapController();
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  List<XFile?> photos = [];
  final List<LatLng> _positions = []; // لیست موقعیت‌ها
  final mapCenter = LatLng(
      AccessLocationScreen.latitudeNotifire.value ?? 35.6892,
      AccessLocationScreen.longitudeNotifire.value ?? 51.3890);
  Future<void> _getLocationAndShowMarker() async {
    // انتقال دوربین به موقعیت جدید
    setState(() {
      final lat = LatLng(35.6892, 51.3890);
      mapController.move(lat, 16);
      _positions.add(lat);
      // mapController.move(mapCenter, 16);
      // _positions.add(mapCenter); // اضافه کردن موقعیت جدید به لیست
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _showMap(),
          VerticalSpace(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ProgressButton(
              //   width: context.screenWidth * 0.3,
              //   height: context.screenHeight * 0.05,
              //   label: 'ثبت موقعیت',
              //   onTap: () {},
              // ),
              ElevatedButton(
                  onPressed: _getLocationAndShowMarker,
                  child: Text('ثبت موقعیت')),
              ElevatedButton(
                  onPressed: () async {
                    photo = await picker.pickImage(source: ImageSource.camera);
                    photos.add(photo);
                  },
                  child: Text('اضافه کردن عکس')),
            ],
          ),
          VerticalSpace(20),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                if (photo == null) return SizedBox();

                return Padding(
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(photo.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )

          // Row(
          //   children: [
          //     Image.file(
          //       photo != null
          //           ? File(photo!.path)
          //           : File('assets/images/placeholder.png'),
          //       width: 200,
          //       height: 100,
          //     ),
          //   ],
          // ),
        ],
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
          width: context.screenWidth * 0.95,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _positions.isNotEmpty
                    ? _positions.last
                    : LatLng(35.6892, 51.3890), // پیش‌فرض تهران
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
            // child: FlutterMap(
            //   mapController: mapController,
            //   options: MapOptions(
            //     initialCenter: LatLng(
            //       AccessLocationScreen.latitudeNotifire.value ?? 36.29608,
            //       AccessLocationScreen.longitudeNotifire.value ?? 59.57204,
            //     ),
            //     initialZoom: 16.5,
            //   ),
            //   children: [
            //     TileLayer(
            //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //     ),
            //     PolylineLayer(
            //       polylines: [
            //         Polyline(
            //           points: [
            //             LatLng(
            //               double.parse(
            //                 AccessLocationScreen.latitudeNotifire.value
            //                     .toString(),
            //                 // '36.29608',
            //               ),
            //               double.parse(
            //                 AccessLocationScreen.longitudeNotifire.value
            //                     .toString(),
            //                 // '59.57204',
            //               ),
            //             ),
            //           ],
            //           strokeWidth: 8,
            //           color: Colors.deepOrange,
            //         ),
            //       ],
            //     ),
            //     MarkerLayer(
            //       markers: [
            //         Marker(
            //           point: LatLng(
            //             double.parse(
            //               AccessLocationScreen.latitudeNotifire.value
            //                   .toString(),
            //               // '36.29608',
            //             ),
            //             double.parse(
            //               AccessLocationScreen.longitudeNotifire.value
            //                   .toString(),
            //               // '59.57204',
            //             ),
            //           ),
            //           child: const Icon(
            //             Icons.location_on,
            //             color: Colors.red,
            //             size: 30,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
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
