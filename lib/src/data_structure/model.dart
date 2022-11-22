class ModelGroup {
  String id;
  String name;
  String taskId;
  String modelTemplateId;
  List<Model> models;

  ModelGroup({
    required this.id,
    required this.name,
    required this.taskId,
    required this.modelTemplateId,
    required this.models
  });

  factory ModelGroup.fromJson({required Map<String, dynamic> json}) {
    List<Model> result = <Model>[];
    for (Map<String, dynamic> item in json['models']){
      result.add(Model.fromJson(json: item));
    }
    return ModelGroup(
      id: json['id'],
      name: json['name'],
      taskId: json['task_id'],
      modelTemplateId: json['model_template_id'],
      models: result
    );
  }
}

class Model {
  String name;
  DateTime creationDate;
  String id;
  int size;
  num performance;
  bool scoreUpToDate;
  bool activeModel;

  Model({
    required this.name,
    required this.creationDate,
    required this.id,
    required this.size,
    required this.performance,
    required this.scoreUpToDate,
    required this.activeModel
  });

  factory Model.fromJson({required Map<String, dynamic> json}) {
    return Model(
      name: json['name'],
      creationDate: DateTime.parse(json['creation_date']),
      id: json['id'],
      size: json['size'],
      performance: json['performance']['score'],
      scoreUpToDate: json['score_up_to_date'],
      activeModel: json['active_model']
    );
  }
}
