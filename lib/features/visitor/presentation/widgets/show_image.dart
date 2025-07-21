import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/common/spacing_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
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
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: widget.photos.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // final reversedIndex = photos.length - 1 - index;
          final photo = widget.photos[index];
          if (photo == null) return SizedBox();
          return Container(
            width: context.screenWidth,
            height: 60,
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey.withAlpha(20)),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(70),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: FileImage(File(photo.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                HorizontalSpace(12),
                Expanded(
                  child: NormalBold(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ'),
                ),
                // bloc.isDeleted
                // index == widget.photos.length - 1 && bloc.isDeleted
                true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.photos.removeAt(index);
                            bloc.isDeleted = false;
                            bloc.photo = null;
                            bloc.capturedImages.removeAt(index);
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.delete,
                          color: ICON_COLOR,
                        ))
                    : EmptyContainer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
