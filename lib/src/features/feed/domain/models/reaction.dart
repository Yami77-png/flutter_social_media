class Reaction {
  final String id;
  final String icon;
  final String name;
  final String reactedBy;

  Reaction({required this.id, required this.icon, required this.name, this.reactedBy = ''});

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(id: map['id'], icon: map['icon'], name: map['react'], reactedBy: map['reactedBy']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'icon': icon, 'react': name, 'reactedBy': reactedBy};
  }
}

enum ReactionEnum { r0, r1, r2, r3, r4 }

List<Reaction> reactions = List.generate(5, (i) {
  return Reaction(id: 'react-$i', icon: 'assets/svg/reaction$i.png', name: 'React-$i');
});

class ReactionResult {
  final int count;
  final String? reactionName;

  ReactionResult({required this.count, this.reactionName});
}
