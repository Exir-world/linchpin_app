import 'dart:io';

import 'package:calendar_pro_farhad/core/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/features/visitor/domain/entity/current_location_entity.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({
    super.key,
    required this.photos,
    required this.currentLocation,
    required this.bloc,
  });

  final List<XFile?> photos;
  final CurrentLocationEntity currentLocation;
  final VisitorBloc bloc;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<XFile?>?>(
        stream: widget.bloc.photos.stream,
        builder: (context, asyncSnapshot) {
          return SizedBox(
            height: context.screenHeight * 0.23,
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // سه ستون
                crossAxisSpacing: 10, // فاصله افقی بین عکس‌ها
                mainAxisSpacing: 5, // فاصله عمودی بین عکس‌ها
                childAspectRatio: 1, // نسبت عرض به ارتفاع (مربع)
              ),
              itemCount: asyncSnapshot.data?.length,
              itemBuilder: (context, index) {
                final photo = asyncSnapshot.data?[index];
                if (photo == null) return SizedBox();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(photo.path),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          );
        });
  }
}
