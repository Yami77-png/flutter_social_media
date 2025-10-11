class ContentCreatorProfileModel {
  final String refId;
  final String ownerName;
  final String foundingDate;
  final String currentAddress;
  final String category;
  final int teamCount;
  final String gender;

  ContentCreatorProfileModel({
    required this.refId,
    required this.ownerName,
    required this.foundingDate,
    required this.currentAddress,
    required this.category,
    required this.teamCount,
    required this.gender,
  });

  // Convert ContentCreatorProfile object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'ownerName': ownerName,
      'foundingDate': foundingDate,
      'currentAddress': currentAddress,
      'category': category,
      'teamCount': teamCount,
      'gender': gender,
    };
  }

  factory ContentCreatorProfileModel.fromMap(Map<String, dynamic> map) {
    return ContentCreatorProfileModel(
      refId: map['refId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      foundingDate: map['foundingDate'] ?? '',
      currentAddress: map['currentAddress'] ?? '',
      category: map['category'] ?? '',
      teamCount: map['teamCount'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}
