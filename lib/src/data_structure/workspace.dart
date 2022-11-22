class Workspace {
  DateTime creationDate;
  String creatorName;
  String description;
  String id;
  String name;

  Workspace(
      {required this.creationDate,
      required this.creatorName,
      required this.description,
      required this.id,
      required this.name});

  factory Workspace.fromJson({required Map<String, dynamic> json}) {
    return Workspace(
        creationDate: DateTime.parse(json['creation_date']),
        creatorName: json['creator_name'],
        description: json['description'],
        id: json['id'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'creation_date': creationDate.toIso8601String(),
      'creator_name': creatorName,
      'description': description,
      'id': id,
      'name': name
    };
  }
}
