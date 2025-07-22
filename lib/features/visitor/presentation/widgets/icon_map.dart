import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/features/access_location/access_location.dart';

class IconMap extends StatelessWidget {
  const IconMap({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 20,
      child: IconButton(
        onPressed: () async {
          LocationService locationService = LocationService();
          var position = await locationService.getUserLocation();
          if (position != null) {
            AccessLocationScreen.latitudeNotifire.value = position.latitude;
            AccessLocationScreen.longitudeNotifire.value = position.longitude;
            mapController.move(
              LatLng(position.latitude, position.longitude),
              16.5,
            );
          }
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
