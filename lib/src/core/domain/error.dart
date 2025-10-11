// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorModel {
  String status;
  String errorText;
  ErrorModel({required this.status, required this.errorText});

  ErrorModel copyWith({String? status, String? errorText}) {
    return ErrorModel(status: status ?? this.status, errorText: errorText ?? this.errorText);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'errorText': errorText};
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(status: map['status'] as String, errorText: map['errorText'] as String);
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) => ErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ErrorModel(status: $status, errorText: $errorText)';

  @override
  bool operator ==(covariant ErrorModel other) {
    if (identical(this, other)) return true;

    return other.status == status && other.errorText == errorText;
  }

  @override
  int get hashCode => status.hashCode ^ errorText.hashCode;
}
