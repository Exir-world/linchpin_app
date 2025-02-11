import 'package:flutter/foundation.dart';

@immutable
class User {
  final int? id;
  final String? name;
  final dynamic profileImage;

  const User({this.id, this.name, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        profileImage: json['profileImage'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileImage': profileImage,
      };
}
