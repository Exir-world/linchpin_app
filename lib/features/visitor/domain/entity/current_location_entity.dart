import 'package:latlong2/latlong.dart';

class CurrentLocationEntity {
  final String? name;
  final String? lat;
  final String? lng;
  final int? id;
  final LatLng? latLng;

  CurrentLocationEntity({this.name, this.lat, this.lng, this.id, this.latLng});
}
