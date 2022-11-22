import 'dataset.dart';
import 'task.dart';

class Project {
  DateTime creationTime;
  String creatorId;
  List<Dataset> datasets;
  String id;
  String name;
  // The tasks are in the order of the pipeline.
  List<Task> tasks;
  num? score;
  String thumbnail;

  Project(
      {required this.creationTime,
      required this.creatorId,
      required this.datasets,
      required this.id,
      required this.name,
      required this.tasks,
      required this.score,
      required this.thumbnail});

  factory Project.fromJson({required Map<String, dynamic> json}) {
    List<Dataset> datasetResult = <Dataset>[];
    List<Task> taskResult = <Task>[];
    for (Map<String, dynamic> item in json['datasets']) {
      datasetResult.add(Dataset.fromJson(json: item));
    }
    List connectionJsons = json['pipeline']['connections'];
    List taskJsons = json['pipeline']['tasks'];
    Map<String, Task> visited = {};
    for (var item in taskJsons) {
      Task task = Task.fromJson(json: item as Map<String, dynamic>);
      visited[task.id] = task;
      // If the first task in pipeline is not found, set it.
      if (taskResult.isEmpty &&
          connectionJsons
                  .where((element) =>
                      element['from'] == task.id || element['to'] == task.id)
                  .length ==
              1) {
        taskResult.add(task);
      }
    }
    // Get the next pipeline block and append tasks in order.
    while (connectionJsons.isNotEmpty) {
      var connectionJson = connectionJsons.removeAt(connectionJsons
          .indexWhere((element) => element['from'] == taskResult.last.id));
      taskResult.add(visited[connectionJson['to']]!);
    }
    return Project(
        creationTime: DateTime.parse(json['creation_time']),
        creatorId: json['creator_id'],
        datasets: datasetResult,
        id: json['id'],
        name: json['name'],
        tasks: taskResult,
        score: (json.containsKey('performance'))
            ? json['performance']['score']
            : 0.0,
        thumbnail: json['thumbnail']);
  }

  /// Return JSON representation of Project for POST
  Map<String, dynamic> toJson() {
    List<Map<String, String>> connections = <Map<String, String>>[];
    Task prev = tasks.first;
    for (int i = 1; i < tasks.length; i++) {
      connections.add({'from': prev.title, 'to': tasks[i].title});
      prev = tasks[i];
    }
    return {
      'name': name,
      'pipeline': {
        'connections': connections,
        'tasks': tasks.map((Task e) => e.toJson()).toList()
      }
    };
  }
}
