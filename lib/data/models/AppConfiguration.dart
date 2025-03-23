class AppConfiguration {
  AppConfiguration({
    required this.appLink,
    required this.iosAppLink,
    required this.appVersion,
    required this.iosAppVersion,
    required this.forceAppUpdate,
    required this.appMaintenance,
    required this.fileUploadSizeLimit,
  });
  late final String appLink;
  late final String iosAppLink;
  late final String appVersion;
  late final String iosAppVersion;
  late final String forceAppUpdate;
  late final String appMaintenance;
  late final String fileUploadSizeLimit;

  late final String tagline;

  AppConfiguration.fromJson(Map<String, dynamic> json) {
    appLink = json['app_link'] ?? "";
    iosAppLink = json['ios_app_link'] ?? "";
    appVersion = json['app_version'] ?? "";
    iosAppVersion = json['ios_app_version'] ?? "";
    forceAppUpdate = json['force_app_update'] ?? "0";
    appMaintenance = json['app_maintenance'] ?? "0";
    tagline = json['tagline'] ?? "";
    fileUploadSizeLimit = json['file_upload_size_limit'] ?? "";
  }
}
