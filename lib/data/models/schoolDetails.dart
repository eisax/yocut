class SchoolDetails {
  String? schoolName;
  String? schoolTagline;
  String? schoolLogo;
  List<String>? schoolImages;

  SchoolDetails(
      {this.schoolName,
      this.schoolTagline,
      this.schoolLogo,
      this.schoolImages});

  SchoolDetails.fromJson(Map<String, dynamic> json) {
    schoolName = json['school_name'];
    schoolTagline = json['school_tagline'];
    schoolLogo = json['school_logo'];
    schoolImages = json['school_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['school_name'] = schoolName;
    data['school_tagline'] = schoolTagline;
    data['school_logo'] = schoolLogo;
    data['school_images'] = schoolImages;
    return data;
  }
}
