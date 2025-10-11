class NotificationModel {
  final String name;
  final String title;
  final String time;
  final String image;
  final bool isHighlighted;

  NotificationModel({
    required this.name,
    required this.title,
    required this.time,
    required this.image,
    this.isHighlighted = false,
  });

  factory NotificationModel.fromMap(Map<String, String> map) {
    return NotificationModel(
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      time: map['time'] ?? '',
      image: map['image'] ?? '',
      isHighlighted: map['highlight'] == 'true',
    );
  }
}
