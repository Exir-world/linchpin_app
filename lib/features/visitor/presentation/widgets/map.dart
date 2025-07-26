import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.context,
    required this.mapController,
    required List<LatLng> positions,
  }) : _positions = positions;

  final BuildContext context;
  final MapController mapController;
  final List<LatLng> _positions;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // LatLng? currentLocation;
  void _initCurrentLocation() async {
    final bloc = context.read<VisitorBloc>();
    LatLng loc = LatLng(
      AccessLocationScreen.latitudeNotifire.value ?? 0.0,
      AccessLocationScreen.longitudeNotifire.value ?? 0.0,
    );
    bloc.currentLocation = loc;
  }

  @override
  void initState() {
    _initCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VisitorBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.screenWidth * 0.9,
          height: context.screenHeight * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: widget.mapController,
              options: MapOptions(
                initialCenter: widget._positions.isNotEmpty
                    ? widget._positions.last
                    : LatLng(
                        AccessLocationScreen.latitudeNotifire.value ?? 35.6892,
                        AccessLocationScreen.longitudeNotifire.value ?? 51.3890,
                      ),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  // urlTemplate:
                  // 'https://api.neshan.org/v2/static?key=${Constants.API_KY_MAP}&type=neshan&zoom=15&center=${AccessLocationScreen.latitudeNotifire.value},${AccessLocationScreen.longitudeNotifire.value}&width=500&height=500&marker=red',
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.linchpinx.app.linchpinx',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: bloc.currentLocation ??
                        LatLng(
                            AccessLocationScreen.latitudeNotifire.value ??
                                39.222,
                            AccessLocationScreen.longitudeNotifire.value ??
                                59.32),
                    child:
                        Icon(Icons.location_on, color: Colors.blue, size: 30),
                  )
                ]),
                MarkerLayer(
                  markers: bloc.visitTargets
                      .asMap()
                      .entries
                      .map(
                        (entry) => Marker(
                          point: entry.value.latLng ?? LatLng(0.0, 0.0),
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
}
