class SetLocationEntity {
  int? userId;
  double? lat;
  double? lng;
  String? report;
  int? checkPointId;
  int? id;
  String? createdAt;
  List<AttachmentsEntity>? attachmentsEntity;

  SetLocationEntity({
    this.userId,
    this.lat,
    this.lng,
    this.report,
    this.checkPointId,
    this.id,
    this.createdAt,
    this.attachmentsEntity,
  });
}

class AttachmentsEntity {
  String? filename;
  String? fileType;
  String? fileUrl;
  String? description;
  int? userCheckPointId;
  int? id;
  String? createdAt;

  AttachmentsEntity(
      {this.filename,
      this.fileType,
      this.fileUrl,
      this.description,
      this.userCheckPointId,
      this.id,
      this.createdAt});
}
