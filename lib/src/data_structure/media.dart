import 'media_information.dart';

class Media {
  String id;
  String uploaderId;
  MediaInformation mediaInformation;
  String name;
  Map<String, String> annotationStatePerTask;
  String thumbnail;
  String type;
  DateTime uploadTime;

  // Extraneous attribute for convenience.
  String datasetId;

  bool get isImage => mediaInformation is ImageMediaInformation;

  Media({
    required this.id,
    required this.uploaderId,
    required this.mediaInformation,
    required this.name,
    required this.annotationStatePerTask,
    required this.thumbnail,
    required this.type,
    required this.uploadTime,
    required this.datasetId
  });

  factory Media.fromJson({required Map<String, dynamic> json, required String datasetId}){
    Map<String, String> result = {};
    for (Map<String, dynamic> item in json['annotation_state_per_task']){
      result[item['task_id']] = item['state'];
    }
    return Media(
      id: json['id'],
      uploaderId: json['uploader_id'],
      mediaInformation: MediaInformation.fromJson(json: json['media_information'] as Map<String, dynamic>, type: json['type']),
      name: json['name'],
      annotationStatePerTask: result,
      thumbnail: json['thumbnail'],
      type: json['type'],
      uploadTime: DateTime.parse(json['upload_time']),
      datasetId: datasetId
    );
  }
}