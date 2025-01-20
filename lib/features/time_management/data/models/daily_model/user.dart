import 'package:flutter/foundation.dart';

@immutable
class User {
  final int? id;
  final String? name;
  final String? phoneNumber;

  const User({this.id, this.name, this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
      };
}
