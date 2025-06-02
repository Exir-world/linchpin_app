import 'package:flutter/foundation.dart';

import 'item.dart';

@immutable
class UserItem {
  final String? type;
  final String? title;
  final List<Item>? items;

  const UserItem({this.type, this.title, this.items});

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        type: json['type'] as String?,
        title: json['title'] as String?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'title': title,
        'items': items?.map((e) => e.toJson()).toList(),
      };
}
