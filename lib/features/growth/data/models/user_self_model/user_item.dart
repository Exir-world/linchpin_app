import 'package:flutter/foundation.dart';

@immutable
class UserItem {
  final String? id;
  final String? title;
  final String? type;
  final String? image;
  final String? color;
  final bool? done;

  const UserItem({
    this.id,
    this.title,
    this.type,
    this.image,
    this.color,
    this.done,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json['String'] as String?,
        title: json['title'] as String?,
        type: json['type'] as String?,
        image: json['image'] as String?,
        color: json['color'] as String?,
        done: json['done'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'image': image,
        'color': color,
        'done': done,
      };
}
