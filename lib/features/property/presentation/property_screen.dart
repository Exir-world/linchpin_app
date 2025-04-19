import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/features/property/presentation/bloc/property_bloc.dart';
import 'package:linchpin/features/property/presentation/detail_property_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  @override
  void initState() {
    BlocProvider.of<PropertyBloc>(context).add(MyPropertyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(
        context,
        true,
        () => Navigator.pop(context),
      ),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          if (state is MyPropertyCompletedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    BigDemiBold('لیست اموال'),
                    SizedBox(height: 24),
                    state.myPropertiesEntity.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: context.screenHeight / 3.2,
                              ),
                              Center(
                                child: NormalRegular(
                                  'اموالی برای شما ثبت نشده',
                                  textColorInLight: Color(0xffCAC4CF),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: state.myPropertiesEntity.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = state.myPropertiesEntity[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPropertyScreen(
                                          property: data.property!,
                                          deliveredAt: data.deliveredAt!,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: 80,
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffFFFFFF),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NormalMedium(data.property!.title!),
                                          Row(
                                            children: [
                                              SmallMedium(
                                                'شماره اموال:',
                                                textColorInLight:
                                                    Color(0xff88719B),
                                              ),
                                              SizedBox(width: 4),
                                              SmallMedium(
                                                data.property!.code!,
                                                textColorInLight:
                                                    Color(0xff88719B),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xffDADADA),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          } else if (state is MyPropertyLoadingState) {
            return LoadingWidget();
          } else if (state is MyPropertyErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<PropertyBloc>(context).add(MyPropertyEvent());
              },
            );
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      ),
    );
  }
}
