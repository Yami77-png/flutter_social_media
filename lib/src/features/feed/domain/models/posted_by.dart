
class PostedBy {
  final String id;
  final String name;
  final String imageUrl;

  PostedBy({required this.id, required this.name, required this.imageUrl});

  PostedBy copyWith({String? id, String? name, String? imageUrl}) {
    return PostedBy(id: id ?? this.id, name: name ?? this.name, imageUrl: imageUrl ?? this.imageUrl);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }

  factory PostedBy.fromMap(Map<String, dynamic> map) {
    return PostedBy(id: map['id'], name: map['name'], imageUrl: map['imageUrl']);
  }

  @override
  String toString() => 'PostedBy(id: $id, name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostedBy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
