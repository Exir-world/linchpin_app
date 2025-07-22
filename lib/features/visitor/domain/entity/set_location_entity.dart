class SetLocationEntity {
  final int? userId;
  final int? checkPointId;
  final int? lat;
  final int? lng;
  final bool? report;
  final List<AttachmentsEntity>? attachments;

  SetLocationEntity({
    this.userId,
    this.checkPointId,
    this.lat,
    this.lng,
    this.report,
    this.attachments,
  });
}

class AttachmentsEntity {
  final String? filename;
  final String? fileType;
  final String? fileUrl;
  final String? description;

  AttachmentsEntity({
    this.filename,
    this.fileType,
    this.fileUrl,
    this.description,
  });
}
