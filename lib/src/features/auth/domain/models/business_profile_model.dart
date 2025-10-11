class BusinessProfileModel {
  final String refId;
  final String ownerName;
  final String regiNumber;
  final String currentAddress;

  BusinessProfileModel({
    required this.refId,
    required this.ownerName,
    required this.regiNumber,
    required this.currentAddress,
  });

  Map<String, dynamic> toMap() {
    return {'refId': refId, 'ownerName': ownerName, 'regiNumber': regiNumber, 'currentAddress': currentAddress};
  }

  factory BusinessProfileModel.fromMap(Map<String, dynamic> map) {
    return BusinessProfileModel(
      refId: map['refId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      regiNumber: map['regiNumber'] ?? '',
      currentAddress: map['currentAddress'] ?? '',
    );
  }
}
