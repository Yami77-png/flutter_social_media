class PhoneNumberCountryCodes {
  final String name;
  final String dialCode;
  final String code;

  PhoneNumberCountryCodes({required this.name, required this.dialCode, required this.code});

  factory PhoneNumberCountryCodes.fromJson(Map<String, dynamic> json) {
    return PhoneNumberCountryCodes(name: json['name'], dialCode: json['dial_code'], code: json['code']);
  }
}
