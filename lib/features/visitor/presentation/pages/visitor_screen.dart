import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/common/progress_button.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart'
    hide Attachments;
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:linchpin/features/visitor/presentation/widgets/selected_location.dart';
import 'package:linchpin/features/visitor/presentation/widgets/show_map.dart';

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
  List<XFile?> photos = [];
  Position? position;
  final List<LatLng> _positions = []; // لیست موقعیت‌ها
  List<CurrentLocationEntity>? options = [];
  List<Items> items = [];
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
      final lat =
          LatLng(position?.latitude ?? 35.6892, position?.longitude ?? 51.3890);
      mapController.move(lat, 16);
      _positions.add(lat);
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
          isNear(bloc.currentLocation!, target.latLng ?? LatLng(0.0, 0.0))) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  @override
  void initState() {
    bloc = getIt<VisitorBloc>()..add(GetLocation());
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
        listener: (context, state) {
          if (state is GetLocationSuccess) {
            items = bloc.items;
            int count = 1;
            for (var element in bloc.visitTargets) {
              options?.add(
                CurrentLocationEntity(
                  lat: element.lat.toString(),
                  lng: element.lng.toString(),
                  name: '${count++} موقعیت',
                  id: element.id,
                ),
              );
            }
          }
          if (state is SetLocationSuccess) {
            bloc.add(GetLocation());
            options?.clear();
            bloc.selectedValue.value.name = null;
            _showSnackbar('عملیات با موفقیت انجام شد.');
          }
        },
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
                    SelectedLocations(
                      options: options ?? [],
                      mapController: mapController,
                      bloc: bloc,
                    ),
                    VerticalSpace(15),
                    // buttonWidgets(context),
                    // VerticalSpace(40),
                    // ShowImage(photos: photos),
                    // VerticalSpace(20),
                    // TextFieldWedget(photos: photos),
                    // VerticalSpace(20),
                    ListView.builder(
                      itemCount: items.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = items[index];
                        return data.userCheckPoints != null
                            ? ListTile(
                                title: SmallBold(
                                    data.userCheckPoints?.createdAt ?? ''),
                              )
                            : EmptyContainer();
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

  Padding buttonWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProgressButton(
            width: context.screenWidth * .32,
            height: 40,
            label: 'ثبت موقعیت',
            onTap: _getLocationAndShowMarker,
          ),
          ProgressButton(
            width: context.screenWidth * .32,
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
                for (var photo in photos) {
                  if (photo != null) {
                    imageFiles.add(
                      Attachments(
                        filename: photo.name,
                        fileUrl: photo.path,
                        fileType: photo.mimeType,
                      ),
                    );
                  }
                }
                setState(() {
                  bloc.add(
                    SetLocationEvent(
                      setLocationRequest: SetLocationRequest(
                        attachments: imageFiles,
                        checkPointId: 0,
                        lat: AccessLocationScreen.latitudeNotifire.value,
                        lng: AccessLocationScreen.longitudeNotifire.value,
                        report: bloc.desc.value,
                      ),
                    ),
                  );
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
    );
  }
}
