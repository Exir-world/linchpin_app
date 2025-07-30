import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/common/progress_button.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_image.dart';
import 'package:linchpin/features/visitor/presentation/widgets/text_field.dart';

class SelectedLocations extends StatefulWidget {
  const SelectedLocations({
    super.key,
    required this.options,
    required this.mapController,
    required this.bloc,
  });

  final List<CurrentLocationEntity>? options;
  final MapController mapController;
  final VisitorBloc bloc;

  @override
  State<SelectedLocations> createState() => _SelectedLocationsState();
}

class _SelectedLocationsState extends State<SelectedLocations> {
  final ImagePicker picker = ImagePicker();
  ValueNotifier<bool> isLoadingNotifire = ValueNotifier(false);
  XFile? photo;
  List<XFile?> photos = [];
  Position? position;

  //! نمایش پیام خطا
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  bool isEnableSendButton() {
    bool result = false;
    for (final target in widget.bloc.visitTargets) {
      if (widget.bloc.currentLocation != null &&
          isNear(widget.bloc.currentLocation!,
              target.latLng ?? LatLng(0.0, 0.0))) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VisitorBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: VERTICAL_SPACING_2x),
      width: context.screenWidth * .9,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VERTICAL_SPACING_1x),
        border: Border.all(width: .5, color: Colors.grey.shade100),
      ),
      child: StreamBuilder<CurrentLocationEntity>(
        stream: bloc.selectedValue.stream,
        builder: (context, asyncSnapshot) {
          return DropdownButton2<String>(
            underline: const EmptyContainer(),
            isExpanded: true,
            hint: const Text(
              'انتخاب موقعیت',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            value: asyncSnapshot.data?.name,
            items: widget.options?.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item.name ?? '',
                child: SmallMedium(
                  item.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              );
            }).toList(),
            onChanged: (newValue) async {
              CurrentLocationEntity? currentLocation;
              bloc.selectedValue.value = CurrentLocationEntity(
                name: newValue,
              );
              currentLocation = widget.options?.firstWhere(
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
                  widget.mapController.move(
                    LatLng(position.latitude, position.longitude),
                    16.5,
                  );
                }
              } else if (currentLocation != null) {
                AccessLocationScreen.latitudeNotifire.value =
                    double.parse(currentLocation.lat.toString());
                AccessLocationScreen.longitudeNotifire.value =
                    double.parse(currentLocation.lng.toString());
                widget.mapController.move(
                  LatLng(double.parse(currentLocation.lat.toString()),
                      double.parse(currentLocation.lng.toString())),
                  16.5,
                );
                showModal(context, currentLocation);
              }
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> showModal(
      BuildContext context, CurrentLocationEntity currentLocation) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: context.screenWidth,
            height: context.screenHeight * 0.6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Center(child: buttonWidgets(context, currentLocation)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: ShowImage(photos: photos),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFieldWedget(
                      photos: photos,
                      bloc: widget.bloc,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding buttonWidgets(
      BuildContext context, CurrentLocationEntity? currentLocation) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProgressButton(
            width: context.screenWidth * .45,
            height: 40,
            label: photos.isEmpty ? 'گرفتن عکس' : 'اضافه کردن عکس',
            onTap: () async {
              if (!isEnableSendButton()) {
                photo = await picker.pickImage(source: ImageSource.camera);
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
            isEnabled:
                photo != null && photos.isNotEmpty && !isEnableSendButton(),
            label: 'ارسال',
            onTap: () async {
              if (!isEnableSendButton()) {
                List<Attachments>? imageFiles = [];
                List<String>? fileName = [];
                for (var photo in photos) {
                  if (photo != null) {
                    fileName.add(photo.path);
                    imageFiles.add(
                      Attachments(
                        filename: photo.name,
                        fileUrl: photo.path,
                        fileType: photo.mimeType,
                      ),
                    );
                  }
                }
                widget.bloc.add(UploadImage(fileName));
                setState(() {
                  widget.bloc.add(
                    SetLocationEvent(
                      setLocationRequest: SetLocationRequest(
                        attachments: imageFiles,
                        checkPointId: currentLocation?.id ?? 0,
                        lat: AccessLocationScreen.latitudeNotifire.value,
                        lng: AccessLocationScreen.longitudeNotifire.value,
                        report: widget.bloc.desc.value,
                      ),
                    ),
                  );
                  photo = null;
                  photos.clear();
                  Navigator.pop(context);
                });
                // ثبت در دیتابیس یا تغییر UI
              } else {
                _showSnackbar('محدوه غیر مجاز');
              }
            },
          ),
        ],
      ),
    );
  }
}
