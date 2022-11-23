import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension DatasetAPI on IntelGetiClient {
  /// Create a [Dataset].
  Future<Dataset> createDataset(
      {required String workspaceId,
      required String projectId,
      required Dataset dataset}) async {
    Response response =
        await post('/workspaces/$workspaceId/projects/$projectId/datasets', dataset.toJson());
    Dataset result =
        Dataset.fromJson(json: response.data as Map<String, dynamic>);
    return result;
  }

  /// Get info about all datasets in [Project].
  Future<List<Dataset>> getDatasets({required String workspaceId, required String projectId}) async {
    Response response = await get('/workspaces/$workspaceId/projects/$projectId');
    List<Dataset> result = <Dataset>[];
    for (Map<String, dynamic> json in response.data['datasets']) {
      result.add(Dataset.fromJson(json: json));
    }
    return result;
  }

  /// Get info about a [Dataset].
  Future<Dataset> getDataset(
      {required String workspaceId, required String projectId, required Dataset datasetId}) async {
    Response response =
        await get('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId');
    Dataset dataset =
        Dataset.fromJson(json: response.data as Map<String, dynamic>);
    return dataset;
  }

  /// Edit a [Dataset].
  Future<Dataset> updateDataset(
      {required String workspaceId, required String projectId, required Dataset dataset}) async {
    Response response = await put(
        '/workspaces/$workspaceId/projects/$projectId/datasets/${dataset.id}', dataset.toJson());
    Dataset updatedDataset =
        Dataset.fromJson(json: response.data as Map<String, dynamic>);
    return updatedDataset;
  }

  /// Delete a [Dataset].
  Future<bool> deleteProject(
      {required String workspaceId, required String projectId, required String datasetId}) async {
    Response response =
        await delete('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId');
    return response.statusCode! == 200;
  }

  /// Get statistics for a [Dataset].
  /// 
  /// TODO - Implementation required - currently not supported.
  Future<Map<String, dynamic>> getDatasetStats({
    required String workspaceId, required String projectId, required String datasetId
  }) async {
    return {};
  }
}
