class ProfessionalProfileModel {
  final String refId;
  final String professional;
  final String designation;
  final String company;
  final String industry;
  final String availability;

  ProfessionalProfileModel({
    required this.refId,
    required this.professional,
    required this.designation,
    required this.company,
    required this.industry,
    required this.availability,
  });

  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'professional': professional,
      'designation': designation,
      'company': company,
      'industry': industry,
      'availability': availability,
    };
  }

  factory ProfessionalProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfessionalProfileModel(
      refId: map['refId'] ?? '',
      professional: map['professional'] ?? '',
      designation: map['designation'] ?? '',
      company: map['company'] ?? '',
      industry: map['industry'] ?? '',
      availability: map['availability'] ?? '',
    );
  }
}
