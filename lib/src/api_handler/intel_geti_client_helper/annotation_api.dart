import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension AnnotationApi on IntelGetiClient {
  /// Create an annotation for [Media] image.
  Future<AnnotationScene> uploadImageAnnotations(
      {required String workspaceId,
      required Project project,
      required String datasetId,
      required String mediaId,
      required AnnotationScene annotationScene}) async {
    Response response = await post(
        '/workspaces/$workspaceId/projects/${project.id}/datasets/$datasetId/media/images/$mediaId/annotations',
        annotationScene.toJson());
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }

  /// Get annotations of [Media] image.
  ///
  /// If there are no annotations for the image, it returns null.
  Future<AnnotationScene?> getImageAnnotations(
      {required String workspaceId,
      required Project project,
      required String datasetId,
      required String mediaId,
      String annotationId = 'latest'}) async {
    Response response = await get(
        '/workspaces/$workspaceId/projects/${project.id}/datasets/$datasetId/media/images/$mediaId/annotations/$annotationId');
    if (response.statusCode! == 204) {
      return null;
    }
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }

  /// Get annotations of [Media] image.
  ///
  /// If there are no annotations for the image, it returns null.
  Future<List<AnnotationScene>?> getVideoAnnotations(
      {required String workspaceId,
      required Project project,
      required String datasetId,
      required String mediaId}) async {
    Response response = await get(
        '/workspaces/$workspaceId/projects/${project.id}/datasets/$datasetId/media/videos/$mediaId/annotations/latest');
    if (response.statusCode! == 204) {
      return null;
    }
    List<AnnotationScene> result = [];
    for (Map<String, dynamic> annoations in response.data['video_annotations']){
      result.add(AnnotationScene.fromJson(json: annoations, project: project));
    }
    return result;
  }

  /// TODO - Implement later
  void createAnnoation(){}

  /// TODO - Implement later
  void getVideoAnnotation() {}

  /// TODO - Implement later
  void getVideoAnnotationRange() {}

  /// TODO - Implement later
  void createAnnotationRange() {}
}
