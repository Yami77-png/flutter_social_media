// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Location {
  final String name;

  final String address;
  Location({required this.name, required this.address});

  Location copyWith({String? name, String? address}) {
    return Location(name: name ?? this.name, address: address ?? this.address);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'address': address};
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(name: map['name'] as String, address: map['address'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Location(name: $name, address: $address)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.name == name && other.address == address;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode;
}
