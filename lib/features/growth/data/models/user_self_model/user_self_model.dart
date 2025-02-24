import 'package:flutter/foundation.dart';
import 'package:Linchpin/features/growth/domain/entity/user_self_entity.dart';

import 'user_item.dart';

@immutable
class UserSelfModel extends UserSelfEntity {
  const UserSelfModel({super.score, super.scoreIcon, super.userItems});

  factory UserSelfModel.fromJson(Map<String, dynamic> json) => UserSelfModel(
        score: json['score'] as int?,
        scoreIcon: json['scoreIcon'] as String?,
        userItems: (json['userItems'] as List<dynamic>?)
            ?.map((e) => UserItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'scoreIcon': scoreIcon,
        'userItems': userItems?.map((e) => e.toJson()).toList(),
      };
}
