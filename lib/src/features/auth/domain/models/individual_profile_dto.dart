enum Quality { excellent, good, average, poor }

enum CurrentStatus { studying, working }

class IndividualProfileDto {
  final String? nickname;
  final Quality? quality;
  final String? currentAddress;
  final String? hometown;
  final String? collegeName;
  final String? subject;
  final CurrentStatus? currentStatus;

  IndividualProfileDto({
    this.nickname,
    this.quality,
    this.currentAddress,
    this.hometown,
    this.collegeName,
    this.subject,
    this.currentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'quality': quality,
      'currentAddress': currentAddress,
      'hometown': hometown,
      'collegeName': collegeName,
      'subject': subject,
      'currentStatus': currentStatus,
    };
  }

  factory IndividualProfileDto.fromMap(Map<String, dynamic> map) {
    return IndividualProfileDto(
      nickname: map['nickname'],
      quality: map['quality'],
      currentAddress: map['currentAddress'],
      hometown: map['hometown'],
      collegeName: map['collegeName'],
      subject: map['subject'],
      currentStatus: map['currentStatus'],
    );
  }
}
