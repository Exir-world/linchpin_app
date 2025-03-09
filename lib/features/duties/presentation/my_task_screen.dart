import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/duties/data/models/task_detail_model/attachment.dart';
import 'package:linchpin/features/duties/data/models/task_detail_model/priority.dart';
import 'package:linchpin/features/duties/data/models/task_detail_model/task_tag.dart';
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin/features/duties/presentation/duties_screen.dart';
import 'package:linchpin/features/duties/presentation/widgets/subtask_widget.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MyTaskScreen extends StatefulWidget {
  final int taskId;
  const MyTaskScreen({super.key, required this.taskId});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen>
    with WidgetsBindingObserver {
  late DutiesBloc _bloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _bloc = getIt<DutiesBloc>();
    _bloc.add(TaskDetailEvent(taskId: widget.taskId));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: appBarRoot(context, true),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: BlocBuilder<DutiesBloc, DutiesState>(
              buildWhen: (previous, current) {
                if (current is TaskDetailCompleted ||
                    current is TaskDetailLoading ||
                    current is TaskDetailError) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is TaskDetailCompleted) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // کارت جزئیات تسک
                      TaskDescWidget(
                        title: state.taskDetailEntity.title!,
                        desc: state.taskDetailEntity.description!,
                        taskTags: state.taskDetailEntity.taskTags!,
                        creatorApprove: state.taskDetailEntity.creatorApprove!,
                        name: state.taskDetailEntity.user!.name!,
                        priority: state.taskDetailEntity.priority!,
                        date: state.taskDetailEntity.date!,
                      ),

                      // کارت پیوست ها
                      state.taskDetailEntity.attachments!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 16),
                                AttachTaskWidget(
                                  attachment:
                                      state.taskDetailEntity.attachments!,
                                ),
                              ],
                            )
                          : SizedBox(),

                      state.taskDetailEntity.subTasks!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 16),
                                SubtaskWidget(
                                  subTask: state.taskDetailEntity.subTasks!,
                                  bloc: _bloc,
                                  isAdmin: false,
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  );
                } else if (state is TaskDetailLoading) {
                  return LoadingWidget();
                } else if (state is TaskDetailError) {
                  return ErrorUiWidget(
                    title: state.textError,
                    onTap: () {
                      _bloc.add(TaskDetailEvent(taskId: widget.taskId));
                    },
                  );
                } else {
                  return Center(child: NormalMedium('data'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

// کارت پیوست ها
class AttachTaskWidget extends StatefulWidget {
  final List<Attachment> attachment;
  const AttachTaskWidget({
    super.key,
    required this.attachment,
  });

  @override
  State<AttachTaskWidget> createState() => _AttachTaskWidgetState();
}

class _AttachTaskWidgetState extends State<AttachTaskWidget> {
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes ${LocaleKeys.byte.tr()}'; // کمتر از 1KB
    } else if (bytes < 1024 * 1024) {
      double kb = bytes / 1024;
      return '${kb.toStringAsFixed(2)} ${LocaleKeys.kByte.tr()}';
    } else if (bytes < 1024 * 1024 * 1024) {
      double mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(2)} ${LocaleKeys.mByte.tr()}';
    } else {
      double gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(2)} ${LocaleKeys.gByte.tr()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 30,
            color: Color(0xff828282).withValues(alpha: 0.04),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Assets.icons.attach.svg(height: 24),
              SizedBox(width: 8),
              NormalMedium('فایل های پیوست'),
            ],
          ),
          SizedBox(height: 24),
          ListView.builder(
            itemCount: widget.attachment.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = widget.attachment[index];
              return Container(
                height: 72,
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffF9F8FE).withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    DownloadButton(
                      fileUrl: data.link!,
                      fileName: data.fileName!,
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SmallMedium(data.fileName!),
                        VerySmallRegular(
                          formatFileSize(data.fileSize!),
                          textColorInLight: Color(0xff88719B),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    data.fileType == 'IMG'
                        ? Assets.images.img.svg()
                        : data.fileType == 'PDF'
                            ? Assets.images.pdf.svg()
                            : data.fileType == 'XLS'
                                ? Assets.images.xls.svg()
                                : Assets.images.mp3.svg(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// کارت جزئیات تسک
class TaskDescWidget extends StatelessWidget {
  final String title;
  final String desc;
  final List<TaskTag> taskTags;
  final bool creatorApprove;
  final String name;
  final Priority priority;
  final String date;
  const TaskDescWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.taskTags,
    required this.creatorApprove,
    required this.name,
    required this.priority,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    int colorFlag = int.parse(priority.color!.replaceAll("#", "0xff"));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 30,
            color: Color(0xff828282).withValues(alpha: 0.04),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              creatorApprove
                  ? Assets.icons.check.svg(height: 24)
                  : Container(
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff030712).withValues(alpha: .12),
                            blurRadius: 0,
                            spreadRadius: 1.2,
                          ),
                          BoxShadow(
                            color: Color(0xff030712).withValues(alpha: .12),
                            blurRadius: 2.4,
                            offset: Offset(0, 1.2),
                          ),
                        ],
                      ),
                    ),
              SizedBox(width: 12),
              NormalMedium(title),
            ],
          ),
          SizedBox(height: 24),
          SmallRegular(
            desc,
            textColorInLight: Color(0xff828282),
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 26,
            child: ListView.builder(
              itemCount: taskTags.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final data = taskTags[index];
                int color = int.parse(data.color!.replaceAll("#", "0xff"));
                int textColor =
                    int.parse(data.textColor!.replaceAll("#", "0xff"));
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TagContainer(
                    title: data.title!,
                    color: color,
                    textColor: textColor,
                    isList: true,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Assets.icons.avatar.svg(),
              SizedBox(width: 8),
              SmallMedium(
                name,
                textColorInLight: Color(0xff88719B),
              ),
              Spacer(),
              PriorityWidget(colorFlag: colorFlag, title: priority.title!),
              Spacer(),
              SmallRegular(
                date,
                textColorInLight: Color(0xff88719B),
              ),
              SizedBox(width: 4),
              Assets.icons.calendar.svg(color: Color(0xff88719B)),
            ],
          ),
        ],
      ),
    );
  }
}

// پرچم و عنوان اهمیت وظیفه
class PriorityWidget extends StatelessWidget {
  final int colorFlag;
  final String title;
  const PriorityWidget({
    super.key,
    required this.colorFlag,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.icons.flag.svg(color: Color(colorFlag)),
        SizedBox(width: 4),
        SmallMedium(
          title,
          textColorInLight: Color(colorFlag),
        ),
      ],
    );
  }
}

class DownloadButton extends StatefulWidget {
  final String fileUrl;
  final String fileName;

  const DownloadButton({
    super.key,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloaded = false;
  bool isDownloading = false;
  int downloadProgress = 0;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _checkFileExists();
  }

  Future<void> _checkFileExists() async {
    Directory? tempDir = await getExternalStorageDirectory();
    filePath = '${tempDir?.path}/${widget.fileName}';
    if (await File(filePath!).exists()) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  Future<void> downloadFile() async {
    try {
      setState(() {
        isDownloading = true;
        downloadProgress = 0;
      });

      await Dio().download(
        widget.fileUrl,
        filePath!,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            int progress = ((received / total) * 100).floor();
            if (progress != downloadProgress) {
              setState(() {
                downloadProgress = progress;
              });
            }
          }
        },
      );

      setState(() {
        isDownloaded = true;
        isDownloading = false;
      });

      _openFile();
    } catch (e) {
      print('Download failed: $e');
      setState(() {
        isDownloading = false;
        downloadProgress = 0;
      });
    }
  }

  Future<void> _openFile() async {
    final result = await OpenFile.open(filePath!);
    print('OpenFile result: ${result.message}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDownloading
          ? null
          : isDownloaded
              ? _openFile // اگر دانلود شده بود، فقط باز کن
              : downloadFile, // اگر دانلود نشده بود، دانلود کن
      child: isDownloading
          ? Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SmallMedium(
                  '$downloadProgress%',
                ),
              ],
            )
          : isDownloaded
              ? Assets.icons.arrowUp.svg(height: 24)
              : const Icon(Icons.file_download_outlined,
                  size: 24, color: Color(0xff861C8C)),
    );
  }
}
