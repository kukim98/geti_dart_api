import 'annotation.dart';
import 'project.dart';



/// This class is for use within [AnnotationScene].
class Mediaidentifier {
  String type;

  Mediaidentifier({required this.type});

  factory Mediaidentifier.fromJson({required Map<String, dynamic> json}) {
    switch (json['type']) {
      case 'image':
        return ImageMediaIdentifier.fromJson(json: json);
      case 'video_frame':
        return VideoFrameMediaIdentifier.fromJson(json: json);
      default:
        return Mediaidentifier(type: 'UNKNOWN');
    }
  }

  Map<String, dynamic> toJson() {
    switch (type) {
      case 'image':
        return (this as ImageMediaIdentifier).toJson();
      case 'video_frame':
        return (this as VideoFrameMediaIdentifier).toJson();
      default:
        return {};
    }
  }
}

class ImageMediaIdentifier extends Mediaidentifier {
  String imageId;

  ImageMediaIdentifier({required super.type, required this.imageId});

  factory ImageMediaIdentifier.fromJson({required Map<String, dynamic> json}){
    return ImageMediaIdentifier(
      type: json['type'],
      imageId: json['image_id']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
      'type': type
    };
  }
}

class VideoFrameMediaIdentifier extends Mediaidentifier {
  String videoId;
  int frameIndex;

  VideoFrameMediaIdentifier({required super.type, required this.videoId, required this.frameIndex});

  factory VideoFrameMediaIdentifier.fromJson({required Map<String, dynamic> json}){
    return VideoFrameMediaIdentifier(
      type: json['type'],
      videoId: json['video_id'],
      frameIndex: json['frame_index']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'type': type,
      'frame_index': frameIndex
    };
  }
}

class AnnotationScene {
  String id;
  String kind;
  Mediaidentifier mediaIdentifier;
  DateTime modified;
  List<Annotation> annotations;

  AnnotationScene({
    required this.id,
    required this.kind,
    required this.mediaIdentifier,
    required this.modified,
    required this.annotations
  });

  factory AnnotationScene.fromJson({required Map<String, dynamic> json, required Project project}){
    List<Annotation> result = <Annotation>[];
    for (Map<String, dynamic> item in json['annotations']){
      result.add(Annotation.fromJson(json: item, project: project));
    }
    return AnnotationScene(
      id: json['id'],
      kind: json['kind'],
      mediaIdentifier: Mediaidentifier.fromJson(json: json['media_identifier']),
      modified: DateTime.parse(json['modified']),
      annotations: result
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> result = [];
    for (Annotation item in annotations){
      result.add(item.toJson());
    }
    return {
      'media_identifier': mediaIdentifier.toJson(),
      'annotations': result,
      'labels_to_revisit_full_scene': []
    };
  }
}

class VideoAnnotationScene {
  int totalCount;
  int startFrame;
  int endFrame;
  int totalRequestedCount;
  int requestedStartFrame;
  int requestedEndFrame;
  List<AnnotationScene> annotationScenes;

  VideoAnnotationScene({
    required this.totalCount,
    required this.startFrame,
    required this.endFrame,
    required this.totalRequestedCount,
    required this.requestedStartFrame,
    required this.requestedEndFrame,
    required this.annotationScenes
  });

  factory VideoAnnotationScene.fromJson({required Map<String, dynamic> json, required Project project}) {
    List<AnnotationScene> result = <AnnotationScene>[];
    for (Map<String, dynamic> item in json['video_annotations']){
      result.add(AnnotationScene.fromJson(json: item, project: project));
    }
    return VideoAnnotationScene(
      totalCount: json['video_annotation_properties']['total_count'],
      startFrame: json['video_annotation_properties']['start_frame'],
      endFrame: json['video_annotation_properties']['end_frame'],
      totalRequestedCount: json['video_annotation_properties']['total_requested_count'],
      requestedStartFrame: json['video_annotation_properties']['requested_start_frame'],
      requestedEndFrame: json['video_annotation_properties']['requested_end_frame'],
      annotationScenes: result
    );
  }
}
