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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['school_name'] = this.schoolName;
    data['school_tagline'] = this.schoolTagline;
    data['school_logo'] = this.schoolLogo;
    data['school_images'] = this.schoolImages;
    return data;
  }
}
