class SetLocationRequest {
  int? checkPointId;
  double? lat;
  double? lng;
  String? report;
  List<Attachments>? attachments;

  SetLocationRequest(
      {this.checkPointId, this.lat, this.lng, this.report, this.attachments});

  SetLocationRequest.fromJson(Map<String, dynamic> json) {
    checkPointId = json['checkPointId'];
    lat = json['lat'];
    lng = json['lng'];
    report = json['report'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkPointId'] = checkPointId;
    data['lat'] = lat;
    data['lng'] = lng;
    data['report'] = report;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  String? filename;
  String? fileType;
  String? fileUrl;
  String? description;

  Attachments({this.filename, this.fileType, this.fileUrl, this.description});

  Attachments.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    fileType = json['fileType'];
    fileUrl = json['fileUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filename'] = filename;
    data['fileType'] = fileType;
    data['fileUrl'] = fileUrl;
    data['description'] = description;
    return data;
  }
}
