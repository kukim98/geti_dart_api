import 'package:dio/dio.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension WorkspaceAPI on IntelGetiClient {
  /// Return all [Workspace] for a given Intel GETi server.
  Future<List<Workspace>> getWorkspaces() async {
    Response response = await get('/workspaces');
    List<Workspace> result = <Workspace>[];
    for (Map<String, dynamic> json in response.data['workspaces']) {
      result.add(Workspace.fromJson(json: json));
    }
    return result;
  }
}
