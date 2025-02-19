import 'package:flutter/foundation.dart';

@immutable
class UserItem {
  final int? id;
  final String? title;
  final String? image;
  final String? color;
  final bool? done;

  const UserItem({this.id, this.title, this.image, this.color, this.done});

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json['id'] as int?,
        title: json['title'] as String?,
        image: json['image'] as String?,
        color: json['color'] as String?,
        done: json['done'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'color': color,
        'done': done,
      };
}
