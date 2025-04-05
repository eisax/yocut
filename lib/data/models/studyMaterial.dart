enum StudyMaterialType { file, youtubeVideo, uploadedVideoUrl, other }

StudyMaterialType getStudyMaterialType(int type) {
  if (type == 1) {
    return StudyMaterialType.file;
  }
  if (type == 2) {
    return StudyMaterialType.youtubeVideo;
  }
  if (type == 3) {
    return StudyMaterialType.uploadedVideoUrl;
  }

  return StudyMaterialType.other;
}

class StudyMaterial {
  late final StudyMaterialType studyMaterialType;

  late final int id;
  late final String fileName;
  late final String fileThumbnail;
  late final String fileUrl;
  late final String fileExtension;

  StudyMaterial(
      {required this.fileExtension,
      required this.fileUrl,
      required this.fileThumbnail,
      required this.fileName,
      required this.id,
      required this.studyMaterialType,
      });

  StudyMaterial.fromJson(Map<String, dynamic> json) {
    studyMaterialType = getStudyMaterialType(int.parse(json['type'] ?? "0"));

    id = json['id'] ?? 0;
    fileName = json['file_name'] ?? "";
    fileThumbnail = json['file_thumbnail'] ?? "";
    fileUrl = json['file_url'] ?? "";
    fileExtension = json['file_extension'] ?? "";
  }
}
