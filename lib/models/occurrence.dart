class Occurrence {
  const Occurrence({
    required this.id,
    required this.type,
    required this.neighborhood,
    required this.description,
    required this.urgency,
    required this.createdAt,
  });

  final int? id;
  final String type;
  final String neighborhood;
  final String description;
  final String urgency;
  final DateTime createdAt;

  Map<String, Object?> toDatabase() => {
    'type': type,
    'neighborhood': neighborhood,
    'description': description,
    'urgency': urgency,
    'created_at': createdAt.toIso8601String(),
  };

  factory Occurrence.fromDatabase(Map<String, Object?> row) {
    return Occurrence(
      id: row['id'] as int,
      type: row['type'] as String,
      neighborhood: row['neighborhood'] as String,
      description: row['description'] as String,
      urgency: row['urgency'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
