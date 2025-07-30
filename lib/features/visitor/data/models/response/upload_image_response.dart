import 'package:linchpin/features/visitor/domain/entity/upload_image_entity.dart';

class UploadImageResponse extends UploadImageEntity {
  final String? originalName;
  final String? url;

  UploadImageResponse({
    this.originalName,
    this.url,
  }) : super(
          originalName: originalName,
          url: url,
        );

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      originalName: json['originalName'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalName': originalName,
      'url': url,
    };
  }
}
