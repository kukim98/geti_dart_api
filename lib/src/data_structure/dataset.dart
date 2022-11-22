class Dataset {
  DateTime creationTime;
  String id;
  String name;
  bool useForTraining;

  Dataset({
    required this.creationTime,
    required this.id,
    required this.name,
    required this.useForTraining
  });

  factory Dataset.fromJson({required Map<String, dynamic> json}){
    return Dataset(
      creationTime: DateTime.parse(json['creation_time']),
      id: json['id'],
      name: json['name'],
      useForTraining: json['use_for_training']
    );
  }
}
