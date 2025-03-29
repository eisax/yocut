class GalleryFile {
  final int? id;
  final String? modalType;
  final int? modalId;
  final String? fileName;
  final String? fileThumbnail;
  final String? type;

  ///[Type will have 1 and 2 value. 1 = Image and 2 = Youtube Video]
  final String? fileUrl;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? fileExtension;
  final String? typeDetail;
  final String? embedYoutubeUrl;

  GalleryFile({
    this.id,
    this.modalType,
    this.modalId,
    this.fileName,
    this.fileThumbnail,
    this.type,
    this.fileUrl,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fileExtension,
    this.typeDetail,
    this.embedYoutubeUrl,
  });

  GalleryFile copyWith({
    int? id,
    String? modalType,
    int? modalId,
    String? fileName,
    String? fileThumbnail,
    String? type,
    String? fileUrl,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    String? fileExtension,
    String? typeDetail,
    String? embedYoutubeUrl,
  }) {
    return GalleryFile(
      id: id ?? this.id,
      modalType: modalType ?? this.modalType,
      modalId: modalId ?? this.modalId,
      fileName: fileName ?? this.fileName,
      fileThumbnail: fileThumbnail ?? this.fileThumbnail,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fileExtension: fileExtension ?? this.fileExtension,
      typeDetail: typeDetail ?? this.typeDetail,
      embedYoutubeUrl: embedYoutubeUrl ?? this.embedYoutubeUrl,
    );
  }

  GalleryFile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        modalType = json['modal_type'] as String?,
        modalId = json['modal_id'] as int?,
        fileName = json['file_name'] as String?,
        fileThumbnail = json['file_thumbnail'] as String?,
        type = json['type'] as String?,
        fileUrl = json['file_url'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'] as String?,
        fileExtension = json['file_extension'] as String?,
        typeDetail = json['type_detail'] as String?,
        embedYoutubeUrl = json['embed_youtube_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'modal_type': modalType,
        'modal_id': modalId,
        'file_name': fileName,
        'file_thumbnail': fileThumbnail,
        'type': type,
        'file_url': fileUrl,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'file_extension': fileExtension,
        'type_detail': typeDetail,
        'embed_youtube_url': embedYoutubeUrl
      };

  bool isSvgImage() => fileExtension?.toLowerCase() == "svg";
}
