class Story {
  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Pengguna',
      description: json['description'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}