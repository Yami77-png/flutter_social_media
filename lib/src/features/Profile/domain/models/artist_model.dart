class Artist {
  final String id;
  final String name;
  final List<String> genres;

  Artist({required this.id, required this.name, required this.genres});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(id: json['id'], name: json['name'], genres: List<String>.from(json['genres']));
  }

  factory Artist.empty() => Artist(id: '', name: '', genres: []);
}
