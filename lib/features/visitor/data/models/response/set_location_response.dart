import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';

class SetLocationResponse extends SetLocationEntity {
  SetLocationResponse({
    super.attachmentsEntity,
    super.checkPointId,
    super.createdAt,
    super.id,
    super.lat,
    super.lng,
    super.report,
    super.userId,
  });

  factory SetLocationResponse.fromJson(Map<String, dynamic> json) {
    return SetLocationResponse(
      userId: json['userId'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      report: json['report'],
      checkPointId: json['checkPointId'],
      id: json['id'],
      createdAt: json['createdAt'],
      attachmentsEntity: json['attachments'] != null
          ? List<Attachments>.from(
              (json['attachments'] as List).map((v) => Attachments.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['lat'] = lat;
    data['lng'] = lng;
    data['report'] = report;
    data['checkPointId'] = checkPointId;
    data['id'] = id;
    data['createdAt'] = createdAt;

    if (attachmentsEntity != null) {
      data['attachments'] = attachmentsEntity!.map((v) {
        if (v is Attachments) {
          return v.toJson();
        } else {
          return {}; // یا throw Exception
        }
      }).toList();
    }

    return data;
  }
}

class Attachments extends AttachmentsEntity {
  Attachments({
    super.filename,
    super.fileType,
    super.fileUrl,
    super.description,
    super.userCheckPointId,
    super.id,
    super.createdAt,
  });

  factory Attachments.fromJson(Map<String, dynamic> json) {
    return Attachments(
      filename: json['filename'],
      fileType: json['fileType'],
      fileUrl: json['fileUrl'],
      description: json['description'],
      userCheckPointId: json['userCheckPointId'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'description': description,
      'userCheckPointId': userCheckPointId,
      'id': id,
      'createdAt': createdAt,
    };
  }
}
