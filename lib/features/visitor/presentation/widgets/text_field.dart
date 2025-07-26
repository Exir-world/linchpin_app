import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class TextFieldWedget extends StatelessWidget {
  const TextFieldWedget({
    required this.photos,
    required this.bloc,
    super.key,
  });
  final List<XFile?> photos;
  final VisitorBloc bloc;
  @override
  Widget build(BuildContext context) {
    return photos.isNotEmpty
        ? SizedBox(
            width: context.screenWidth * .9,
            // height: 40,
            child: TextField(
              onChanged: (value) {
                bloc.checkTextField(value);
              },
              maxLines: 3,
              decoration: InputDecoration(
                hint: SmallBold(
                  'توضیحات',
                  textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR.withAlpha(80),
                ),
                fillColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ICON_COLOR, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
        : EmptyContainer();
  }
}
