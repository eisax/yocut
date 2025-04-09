class Credentials {
  final String? regNumber;
  final String? token;


  Credentials({
    this.regNumber,
    this.token,
  });

  Credentials copyWith({
    String? regNumber,
    String? token,
  }) {
    return Credentials(
      regNumber: regNumber ?? this.regNumber,
      token: token ?? this.token,
    );
  }

  Credentials.fromJson(Map<String, dynamic> json)
      : regNumber = json['reg_number'] as String?,
        token = json['token'] as String?;

  Map<String, dynamic> toJson() => {
        'reg_number': regNumber,
        'token': token,
      };
}
