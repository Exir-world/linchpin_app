import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class SelectedLocations extends StatelessWidget {
  const SelectedLocations({
    super.key,
    required this.options,
    required this.mapController,
  });

  final List<CurrentLocationEntity>? options;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VisitorBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: VERTICAL_SPACING_2x),
      width: context.screenWidth * .9,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(VERTICAL_SPACING_1x),
        border: Border.all(width: .5, color: Colors.grey.shade300),
      ),
      child: StreamBuilder<CurrentLocationEntity>(
        stream: bloc.selectedValue.stream,
        builder: (context, asyncSnapshot) {
          return DropdownButton<String>(
            menuWidth: context.screenWidth * .93,
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.grey.shade100,
            underline: const EmptyContainer(),
            isExpanded: true,
            value: asyncSnapshot.data?.name != null &&
                    asyncSnapshot.data!.name!.isEmpty
                ? 'انتخاب موقعیت'
                : asyncSnapshot.data?.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: TEXT_DARK_COLOR,
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: ICON_COLOR,
            ),
            onChanged: (String? newValue) async {
              CurrentLocationEntity? currentLocation;
              bloc.selectedValue.value = CurrentLocationEntity(
                name: newValue,
              );
              currentLocation = options?.firstWhere(
                (element) => element.name == newValue,
              );
              if (newValue == 'انتخاب موقعیت') {
                LocationService locationService = LocationService();
                var position = await locationService.getUserLocation();
                if (position != null) {
                  AccessLocationScreen.latitudeNotifire.value =
                      position.latitude;
                  AccessLocationScreen.longitudeNotifire.value =
                      position.longitude;
                  mapController.move(
                    LatLng(position.latitude, position.longitude),
                    16.5,
                  );
                }
              } else if (currentLocation != null) {
                AccessLocationScreen.latitudeNotifire.value =
                    double.parse(currentLocation.lat.toString());
                AccessLocationScreen.longitudeNotifire.value =
                    double.parse(currentLocation.lng.toString());
                mapController.move(
                  LatLng(double.parse(currentLocation.lat.toString()),
                      double.parse(currentLocation.lng.toString())),
                  16.5,
                );
              }
            },
            items: options?.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item.name ?? '',
                child: SmallBold(item.name ?? ''),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
