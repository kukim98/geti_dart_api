import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension ProjectAPI on IntelGetiClient {
  /// Create a [Project].
  Future<Project> createProject(
      {required Workspace workspace, required Project project}) async {
    Response response =
        await post('/workspaces/${workspace.id}/projects', project.toJson());
    Project result =
        Project.fromJson(json: response.data as Map<String, dynamic>);
    return result;
  }

  /// Get info about all projects in [Workspace].
  Future<List<Project>> getProjects({required Workspace workspace}) async {
    Response response = await get('/workspaces/${workspace.id}/projects');
    List<Project> result = <Project>[];
    for (Map<String, dynamic> json in response.data['projects']) {
      result.add(Project.fromJson(json: json));
    }
    return result;
  }

  /// Get info about a [Project].
  Future<Project> getProject(
      {required Workspace workspace, required String projectId}) async {
    Response response =
        await get('/workspaces/${workspace.id}/projects/$projectId');
    Project project =
        Project.fromJson(json: response.data as Map<String, dynamic>);
    return project;
  }

  /// Edit a [Project].
  Future<Project> updateProject(
      {required Workspace workspace, required Project project}) async {
    Response response = await put(
        '/workspaces/${workspace.id}/projects/${project.id}', project.toJson());
    Project updatedProject =
        Project.fromJson(json: response.data as Map<String, dynamic>);
    return updatedProject;
  }

  /// Delete a [Project].
  Future<bool> deleteProject(
      {required Workspace workspace, required String projectId}) async {
    Response response =
        await delete('/workspaces/${workspace.id}/projects/$projectId');
    return response.statusCode! == 200;
  }
}
