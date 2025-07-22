import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({
    super.key,
    required this.photos,
  });

  final List<XFile?> photos;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VisitorBloc>();
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: widget.photos.length,
      itemBuilder: (context, index) {
        final photo = widget.photos[index];
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
    );
  }
}
