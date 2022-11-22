import 'label.dart';

class Task {
  static final List<String> nonTrainableTasks = ['dataset', 'crop'];

  String id;
  String taskType;
  String title;

  Task({required this.id, required this.taskType, required this.title});

  factory Task.fromJson({required Map<String, dynamic> json}) {
    if (nonTrainableTasks.contains(json['task_type'])) {
      return Task(
          id: json['id'], taskType: json['task_type'], title: json['title']);
    } else {
      return TrainableTask.fromJson(json: json);
    }
  }

  Map<String, dynamic> toJson() {
    if (nonTrainableTasks.contains('task_type')) {
      return {'task_type': taskType, 'title': title};
    } else {
      return (this as TrainableTask).toJson();
    }
  }
}

class TrainableTask extends Task {
  String? labelSchemaId;
  List<Label> labels;

  TrainableTask(
      {required super.id,
      required super.taskType,
      required super.title,
      required this.labelSchemaId,
      required this.labels});

  factory TrainableTask.fromJson({required Map<String, dynamic> json}) {
    List<Label> result = <Label>[];
    for (Map<String, dynamic> item in json['labels']) {
      result.add(Label.fromJson(json: item));
    }
    return TrainableTask(
        id: json['id'],
        taskType: json['task_type'],
        title: json['title'],
        labelSchemaId: json['label_schema_id'],
        labels: result);
  }

  Map<String, dynamic> toJson() {
    return {
      'task_type': taskType,
      'title': title,
      'labels': labels.map((Label e) => e.toJson()).toList()
    };
  }
}
