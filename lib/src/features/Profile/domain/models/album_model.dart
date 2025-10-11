class Album {
  final String id;
  final String name;
  final List<String> images;

  Album({required this.id, required this.name, required this.images});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      images: List<String>.from((json['images'] as List<dynamic>).map((img) => img['url'])),
    );
  }

  factory Album.empty() => Album(id: '', name: '', images: []);
}
