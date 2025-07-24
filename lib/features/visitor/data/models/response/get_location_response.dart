import 'package:linchpin/features/visitor/domain/entity/get_location_entity.dart';

class GetLocationImpl extends GetLocationEntity {
  GetLocationImpl({required super.itemsEntity});

  factory GetLocationImpl.fromJson(Map<String, dynamic> json) {
    List<Items> parsedItems = [];
    if (json['items'] != null) {
      parsedItems =
          (json['items'] as List).map((v) => Items.fromJson(v)).toList();
    }
    return GetLocationImpl(itemsEntity: parsedItems);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': itemsEntity.map((v) => v.toJson()).toList(),
    };
  }
}

class Items {
  int? id;
  String? lat;
  String? lng;
  int? radius;
  bool? needReport;
  int? checkPointId;
  UserCheckPoints? userCheckPoints;

  Items({
    this.id,
    this.lat,
    this.lng,
    this.radius,
    this.needReport,
    this.checkPointId,
    this.userCheckPoints,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      radius: json['radius'],
      needReport: json['needReport'],
      checkPointId: json['checkPointId'],
      userCheckPoints: json['userCheckPoints'] != null
          ? UserCheckPoints.fromJson(json['userCheckPoints'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'needReport': needReport,
      'checkPointId': checkPointId,
      'userCheckPoints': userCheckPoints?.toJson(),
    };
  }
}

class UserCheckPoints {
  int? id;
  int? userId;
  String? lat;
  String? lng;
  String? report;
  String? createdAt;
  int? checkPointItemId;
  List<Attachments>? attachments;

  UserCheckPoints({
    this.id,
    this.userId,
    this.lat,
    this.lng,
    this.report,
    this.createdAt,
    this.checkPointItemId,
    this.attachments,
  });

  factory UserCheckPoints.fromJson(Map<String, dynamic> json) {
    return UserCheckPoints(
      id: json['id'],
      userId: json['userId'],
      lat: json['lat'],
      lng: json['lng'],
      report: json['report'],
      createdAt: json['createdAt'],
      checkPointItemId: json['checkPointItemId'],
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((v) => Attachments.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'lat': lat,
      'lng': lng,
      'report': report,
      'createdAt': createdAt,
      'checkPointItemId': checkPointItemId,
      'attachments': attachments?.map((v) => v.toJson()).toList(),
    };
  }
}

class Attachments {
  int? id;
  String? filename;
  String? fileType;
  String? fileUrl;
  String? description;
  String? createdAt;
  int? userCheckPointId;

  Attachments({
    this.id,
    this.filename,
    this.fileType,
    this.fileUrl,
    this.description,
    this.createdAt,
    this.userCheckPointId,
  });

  factory Attachments.fromJson(Map<String, dynamic> json) {
    return Attachments(
      id: json['id'],
      filename: json['filename'],
      fileType: json['fileType'],
      fileUrl: json['fileUrl'],
      description: json['description'],
      createdAt: json['createdAt'],
      userCheckPointId: json['userCheckPointId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'description': description,
      'createdAt': createdAt,
      'userCheckPointId': userCheckPointId,
    };
  }
}
