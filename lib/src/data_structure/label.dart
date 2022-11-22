import 'project.dart';
import 'task.dart';

class Label {
  String color;
  String group;
  String hotkey;
  String id;
  bool isEmpty;
  String name;
  String? parentId;

  Label(
      {required this.color,
      required this.group,
      required this.hotkey,
      required this.id,
      required this.isEmpty,
      required this.name,
      this.parentId});

  factory Label.fromJson({required Map<String, dynamic> json}) {
    return Label(
        color: json['color'],
        group: json['group'],
        hotkey: json['hotkey'],
        id: json['id'],
        isEmpty: json['is_empty'],
        name: json['name'],
        parentId: json['parent_id']);
  }

  factory Label.copyFrom({required Label original}) {
    return Label(
        color: original.color,
        group: original.group,
        hotkey: original.hotkey,
        id: original.id,
        isEmpty: original.isEmpty,
        name: original.name);
  }

  factory Label.dummy({String color = '#ff0000ff'}) {
    return Label(
        color: color, group: '', hotkey: '', id: '', isEmpty: false, name: '');
  }

  Map<String, dynamic> toJson() {
    return {'color': color, 'group': group, 'hotkey': hotkey, 'name': name};
  }
}

class AnnotationLabel {
  Label label;
  num probability;
  String userId;

  AnnotationLabel(
      {required this.label, required this.probability, required this.userId});

  factory AnnotationLabel.fromJson(
      {required Map<String, dynamic> json, required Project project}) {
    return AnnotationLabel(
        label: _matchingLabel(labelId: json['id'], project: project),
        probability: json['probability'],
        userId: json['source']['user_id']);
  }

  factory AnnotationLabel.copyFrom({required AnnotationLabel original}) {
    return AnnotationLabel(
        label: Label.copyFrom(original: original.label),
        probability: original.probability,
        userId: original.userId);
  }

  factory AnnotationLabel.dummy({String color = "#ff0000ff"}) {
    return AnnotationLabel(
        label: Label.dummy(color: color), probability: 1.0, userId: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': label.id,
      'name': label.name,
      'color': label.color,
      'probability': probability
    };
  }

  static Label _matchingLabel(
      {required String labelId, required Project project}) {
    for (Task task in project.tasks) {
      if (task is TrainableTask) {
        for (Label label in task.labels) {
          if (label.id == labelId) {
            return label;
          }
        }
      }
    }
    throw AssertionError('ERROR - Matching label not found');
  }
}
