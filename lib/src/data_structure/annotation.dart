import '../helper/helper.dart';
import 'annotation_shape.dart';
import 'label.dart';
import 'project.dart';

class Annotation {
  String id;
  List<AnnotationLabel> labels;
  DateTime modified;
  AnnotationShape shape;

  Annotation({
    required this.id,
    required this.labels,
    required this.modified,
    required this.shape
  });

  factory Annotation.fromJson({required Map<String, dynamic> json, required Project project}) {
    List<AnnotationLabel> result = <AnnotationLabel>[];
    for (Map<String, dynamic> item in json['labels']){
      result.add(AnnotationLabel.fromJson(json: item, project: project));
    }
    return Annotation(
      id: json['id'],
      labels: result,
      modified: DateTime.parse(json['modified']),
      shape: AnnotationShape.fromJson(json: json['shape'])
    );
  }

  factory Annotation.copyFrom({required Annotation original}) {
    return Annotation(
      id: original.id,
      labels: original.labels.map((AnnotationLabel original) => AnnotationLabel.copyFrom(original: original)).toList(),
      modified: original.modified,
      shape: AnnotationShape.copyFrom(original: original.shape)
    );
  }

  factory Annotation.dummy({required String type}) {
    return Annotation(
      id: '${generateRandomString(8)}-${generateRandomString(4)}-${generateRandomString(4)}-${generateRandomString(4)}-${generateRandomString(12)}',
      labels: [AnnotationLabel.dummy()],
      modified: DateTime.now(),
      shape: AnnotationShape.dummy(type: type)
    );
  }

  bool isDummy() {
    return shape.isDummy();
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = [];
    for (AnnotationLabel label in labels) {
      result.add(label.toJson());
    }
    return {
      'id': id,
      'shape': shape.toJson(),
      'labels': result,
      'labels_to_revisit': []
    };
  }
}