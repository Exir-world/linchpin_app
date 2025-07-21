import 'package:flutter/foundation.dart';

@immutable
class Attachment {
  final int? id;
  final String? fileType;
  final String? fileName;
  final DateTime? createdAt;
  final int? fileSize;
  final String? link;

  const Attachment({
    this.id,
    this.fileType,
    this.fileName,
    this.createdAt,
    this.fileSize,
    this.link,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json['id'] as int?,
        fileType: json['fileType'] as String?,
        fileName: json['fileName'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        fileSize: json['fileSize'] as int?,
        link: json['link'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileType': fileType,
        'fileName': fileName,
        'createdAt': createdAt?.toIso8601String(),
        'fileSize': fileSize,
        'link': link,
      };
}
