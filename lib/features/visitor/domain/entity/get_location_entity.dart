import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart';

class GetLocationEntity {
  final List<Items> itemsEntity;

  GetLocationEntity({required this.itemsEntity});
}

// class Items {
//   int? id;
//   String? lat;
//   String? lng;
//   int? radius;
//   bool? needReport;
//   int? checkPointId;
//   UserCheckPoints? userCheckPoints;

//   Items({
//     this.id,
//     this.lat,
//     this.lng,
//     this.radius,
//     this.needReport,
//     this.checkPointId,
//     this.userCheckPoints,
//   });
// }

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
}
