import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension PredictionApi on IntelGetiClient {
  /// Get AI prediction for an image.
  ///
  /// If there are no predictions available for the image, it returns null.
  /// This is primarily due to the lack of a trained model.
  Future<AnnotationScene?> getPrediction(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Media media,
      String predictionType = 'latest'}) async {
    Response response = await get(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media/images/${media.id}/predictions/$predictionType');
    if (response.statusCode! == 204) {
      return null;
    }
    AnnotationScene result =
        AnnotationScene.fromJson(json: response.data, project: project);
    return result;
  }
}
