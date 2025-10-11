class KnotModel {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;

  KnotModel({required this.id, required this.userId, required this.name, required this.imageUrl});

  KnotModel copyWith({String? id, String? userId, String? name, String? imageUrl}) {
    return KnotModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'userId': userId, 'name': name, 'imageUrl': imageUrl};
  }

  factory KnotModel.fromMap(Map<String, dynamic> map) {
    return KnotModel(id: map['id'], userId: map['userId'], name: map['name'], imageUrl: map['imageUrl']);
  }

  @override
  String toString() => 'KnotInfo: id: $id, userId: $userId name: $name, imageUrl: $imageUrl';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnotModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
