import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intel_geti_api/src/data_structure/data_structure.dart';

import '../intel_geti_client.dart';

extension MediaAPI on IntelGetiClient {
  static const List<String> validMediaQueries = [
    'limit',
    'skip',
    'sort_direction',
    'sort_by'
  ];
  static const List<String> validOperators = [
    'greater',
    'less',
    'greater_or_equal',
    'less_or_equal',
    'equal',
    'not_equal',
    'in',
    'not_in'
  ];
  static const Map<String, Type> validFilterType = {
    'media_upload_date': String,
    'media_height': num,
    'media_width': num,
    'media_name': String,
    'label_id': String,
    'annotation_creation_date': String,
    'shape_type': String,
    'user_name': String
  };

  // #region MEDIA
  /// Get all the [Media].
  ///
  /// The returned [Map] has the following structure:
  /// {
  ///   'media': [List] of [Media] from the query,
  ///   'next_page': [String] URL for next set of [Media].
  /// }
  Future<Map<String, dynamic>> getMedia(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      bool? onlyImages,
      int limit = 100,
      String? skiptoken}) async {
    Response response = await get(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media${(onlyImages == null) ? '' : ((onlyImages) ? '/images' : '/videos')}:query?limit=$limit${(skiptoken == null) ? '' : '&skiptoken=$skiptoken'}');
    List<Media> result = <Media>[];
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  /// Return following media items given the next_page URL from GETi.
  Future<Map<String, dynamic>> getNextMedia(
      {required String nextUrl, int limit = 100}) async {
    Response response = await get('$nextUrl&limit=$limit');
    List<Media> result = <Media>[];
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  String queryBuilder({required Map<String, dynamic> queries}) {
    if (queries.isEmpty) {
      return ':query';
    }
    String res = ':query?';
    for (String key in queries.keys) {
      if (validMediaQueries.contains(key)) {
        res = '$res$key=${queries[key]}&';
      }
    }
    return res.substring(0, res.length - 1);
  }

  Map<String, dynamic> ruleBuilder(
      {required String field,
      required String operator,
      required dynamic value}) {
    return {'field': field, 'operator': operator, 'value': value};
  }

  Map<String, dynamic> filterBuilder(
      {required String condition,
      required List<Map<String, dynamic>> filters}) {
    return {'condition': condition, 'rules': filters};
  }

  /// Return media in a dataset of a project with advanced filters.
  ///
  /// The valid URL query strings are [validMediaQueries].
  ///
  Future<Map<String, dynamic>> getMediaFiltered(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Map<String, dynamic> queries,
      required Map<String, dynamic> filters}) async {
    Response response = await post(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media${queryBuilder(queries: queries)}',
        filters);
    List<Media> result = <Media>[];
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  /// Upload an image.
  Future<Media> uploadMedia(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Uint8List image,
      String filename = 'sample.png'}) async {
    FormData data = FormData.fromMap({
      'file': MultipartFile.fromBytes(image,
          filename: filename, contentType: MediaType('image', 'png'))
    });
    Response response = await post(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media/images',
        data);
    Media result = Media.fromJson(json: response.data);
    return result;
  }

  /// Delete an image.
  ///
  /// Returns appropriate message after operation.
  Future<String> deleteMedia(
      {required Workspace workspace,
      required Project project,
      required Dataset dataset,
      required Media media}) async {
    Response response = await delete(
        '/workspaces/${workspace.id}/projects/${project.id}/datasets/${dataset.id}/media/${(media.mediaInformation is ImageMediaInformation) ? 'images' : 'videos'}/${media.id}');
    return response.data['message'];
  }
}
