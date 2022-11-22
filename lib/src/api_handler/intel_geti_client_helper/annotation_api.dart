import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension AnnotationApi on IntelGetiClient {
  /// Get annotations of an image.
  ///
  /// If there are no annotations for the image, it returns null.
  Future<AnnotationScene?> getAnnotations(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Media media,
      String annotationId = 'latest'}) async {
    Response response = await get(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media/images/${media.id}/annotations/$annotationId');
    if (response.statusCode! == 204) {
      return null;
    }
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }

  /// Upload annotations for an image.
  Future<AnnotationScene> uploadAnnotations(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Media media,
      required AnnotationScene annotationScene}) async {
    Response response = await post(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media/images/${media.id}/annotations',
        annotationScene.toJson());
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }
}
