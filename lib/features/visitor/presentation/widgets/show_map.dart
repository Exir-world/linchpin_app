import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/features/visitor/presentation/widgets/icon_map.dart';
import 'package:linchpin/features/visitor/presentation/widgets/map.dart';

class ShowMap extends StatelessWidget {
  const ShowMap({
    super.key,
    required this.context,
    required this.mapController,
    required List<LatLng> positions,
  }) : _positions = positions;

  final BuildContext context;
  final MapController mapController;
  final List<LatLng> _positions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapScreen(
          context: context,
          mapController: mapController,
          positions: _positions,
        ),
        IconMap(mapController: mapController),
      ],
    );
  }
}
