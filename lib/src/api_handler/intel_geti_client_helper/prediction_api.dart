import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension PredictionApi on IntelGetiClient {
  /// Get a prediction for a [Media] image.
  ///
  /// If there are no predictions available for the image, it returns null.
  /// This is primarily due to the lack of a trained model.
  Future<AnnotationScene?> getImagePrediction(
      {required String workspaceId,
      required Project project,
      required String datasetId,
      required String mediaId,
      String predictionType = 'latest'}) async {
    Response response = await get(
        '/workspaces/$workspaceId/projects/${project.id}/datasets/$datasetId/media/images/$mediaId/predictions/$predictionType');
    if (response.statusCode! == 204) {
      return null;
    }
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }
}
