import 'package:flutter/foundation.dart';

@immutable
class TypeStyles {
  final String? icon;
  final String? color;

  const TypeStyles({this.icon, this.color});

  factory TypeStyles.fromJson(Map<String, dynamic> json) => TypeStyles(
        icon: json['icon'] as String?,
        color: json['color'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'color': color,
      };
}
