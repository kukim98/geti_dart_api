import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension ModelApi on IntelGetiClient {
  /// Get AI prediction for an image.
  ///
  /// If there are no predictions available for the image, it returns null.
  /// This is primarily due to the lack of a trained model.
  Future<List<ModelGroup>> getTrainedModels(
      {required Workspace workspace, required Project project}) async {
    Response response = await get(
        '/workspaces/${workspace.id}/projects/${project.id}/model_groups');
    List<ModelGroup> result = [];
    for (Map<String, dynamic> json in response.data['model_groups']) {
      result.add(ModelGroup.fromJson(json: json));
    }
    return result;
  }

  /// Get list of supported algorithms for model training.
  Future<List<SupportedAlgorithm>> getSupportedModels(
      {String? taskType}) async {
    Response response = await get(
        '/supported_algorithms${(taskType == null) ? '' : '?task_type=$taskType'}');
    List<SupportedAlgorithm> result = [];
    for (Map<String, dynamic> json in response.data['supported_algorithms']) {
      result.add(SupportedAlgorithm.fromJson(json: json));
    }
    return result;
  }

  /// Initiate model training.
  Future<String> trainModle(
      {required Workspace workspace,
      required Project project,
      required Task task,
      required SupportedAlgorithm model}) async {
    Response response =
        await post('/workspaces${workspace.id}/projects/${project.id}/train', {
      'model_template_id': model.modelTemplateId,
      'task_id': task.id,
      'train_from_scratch': true,
      'enable_pot_optimization': false
    });
    return response.data['description'];
  }
}
