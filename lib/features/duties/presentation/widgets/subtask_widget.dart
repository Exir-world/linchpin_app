import 'package:flutter/material.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/features/duties/data/models/task_detail_model/sub_task.dart';
import 'package:linchpin/features/duties/presentation/bloc/duties_bloc.dart';
import 'package:linchpin/gen/assets.gen.dart';

class SubtaskWidget extends StatefulWidget {
  final List<SubTask> subTask;
  final DutiesBloc bloc;
  final bool isAdmin;
  const SubtaskWidget({
    super.key,
    required this.subTask,
    required this.bloc,
    required this.isAdmin,
  });

  @override
  State<SubtaskWidget> createState() => _SubtaskWidgetState();
}

class _SubtaskWidgetState extends State<SubtaskWidget> {
  late List<SubTask> subTasks;
  @override
  void initState() {
    subTasks = widget.subTask;
    super.initState();
  }

  void _toggleSubtask(int index) {
    setState(() {
      subTasks[index] = SubTask(
        id: subTasks[index].id,
        title: subTasks[index].title,
        done: !subTasks[index].done!,
      );
    });

    widget.bloc.add(SubtaskDoneEvent(
      subtaskId: subTasks[index].id!,
      done: subTasks[index].done!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 30,
            color: Color(0xff828282).withValues(alpha: 0.04),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        children: [
          Row(
            children: [
              Assets.icons.task.svg(height: 24),
              SizedBox(width: 8),
              NormalMedium('ساب تسک ها'),
            ],
          ),
          SizedBox(height: 24),
          ListView.builder(
            itemCount: subTasks.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = subTasks[index];
              return GestureDetector(
                onTap: widget.isAdmin ? null : () => _toggleSubtask(index),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      data.done!
                          ? Assets.icons.check.svg()
                          : Assets.icons.cir.svg(),
                      SizedBox(width: 12),
                      NormalRegular(
                        data.title!,
                        decoration:
                            data.done! ? TextDecoration.lineThrough : null,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
