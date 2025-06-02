import 'package:flutter/foundation.dart';

@immutable
class Item {
  final int? id;
  final String? title;
  final String? type;
  final String? image;
  final String? color;
  final List<dynamic>? score;
  final bool? hasSub;
  final bool? done;

  const Item({
    this.id,
    this.title,
    this.type,
    this.image,
    this.color,
    this.score,
    this.hasSub,
    this.done,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as int?,
        title: json['title'] as String?,
        type: json['type'] as String?,
        image: json['image'] as String?,
        color: json['color'] as String?,
        score: json['score'] as List<dynamic>?,
        hasSub: json['hasSub'] as bool?,
        done: json['done'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'image': image,
        'color': color,
        'score': score,
        'hasSub': hasSub,
        'done': done,
      };
}
