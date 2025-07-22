import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/common/empty_container.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

class TextFieldWedget extends StatelessWidget {
  const TextFieldWedget({
    required this.photos,
    super.key,
  });
  final List<XFile?> photos;
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VisitorBloc>();
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
              ),
            ),
          )
        : EmptyContainer();
  }
}
