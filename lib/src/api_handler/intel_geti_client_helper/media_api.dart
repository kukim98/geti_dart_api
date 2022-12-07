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

  /// Get all the [Media].
  ///
  /// The returned [Map] has the following structure:
  /// {
  ///   'media': [List] of [Media] from the query,
  ///   'next_page': [String] URL for next set of [Media].
  /// }
  Future<Map<String, dynamic>> getMedia(
      {required String workspaceId,
      required String projectId,
      required String datasetId,
      bool? onlyImages,
      int limit = 100,
      String? skiptoken}) async {
    Response response = await get(
        '/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media${(onlyImages == null) ? '' : ((onlyImages) ? '/images' : '/videos')}:query?limit=$limit${(skiptoken == null) ? '' : '&skiptoken=$skiptoken'}');
    List<Media> result = <Media>[];
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json, datasetId: datasetId));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  /// Return following media items given the next_page URL from GETi.
  Future<Map<String, dynamic>> getNextMedia(
      {required String nextUrl, int limit = 100}) async {
    Response response = await get('$nextUrl&limit=$limit');
    List<Media> result = <Media>[];
    String datasetId = nextUrl.substring(
      nextUrl.indexOf('datasets/') + 'datasets/'.length,
      nextUrl.indexOf('/', nextUrl.indexOf('datasets/') + 'datasets/'.length)
    );
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json, datasetId: datasetId));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  /// Return media in a dataset of a project with advanced filters.
  ///
  /// The valid URL query strings are [validMediaQueries].
  Future<Map<String, dynamic>> getMediaFiltered(
      {required String workspaceId,
      required String projectId,
      required String datasetId,
      required Map<String, dynamic> queries,
      required Map<String, dynamic> filters}) async {
    Response response = await post(
        '/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media${queryBuilder(queries: queries)}',
        filters);
    List<Media> result = <Media>[];
    for (Map<String, dynamic> json in response.data['media']) {
      result.add(Media.fromJson(json: json, datasetId: datasetId));
    }
    return {'media': result, 'next_page': response.data['next_page']};
  }

  /// Upload an image.
  Future<Media> uploadImage(
      {required String workspaceId,
      required String projectId,
      required String datasetId,
      required Uint8List image,
      String filename = 'sample.png'}) async {
    FormData data = FormData.fromMap({
      'file': MultipartFile.fromBytes(image,
          filename: filename, contentType: MediaType('image', filename.split('.').last))
    });
    Response response = await post(
        '/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/images',
        data);
    Media result = Media.fromJson(json: response.data, datasetId: datasetId);
    return result;
  }

  /// Get [Media] detail.
  Future<Media> getMediaDetail({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId,
    bool isImage = true
  }) async {
    Response response = await get('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/${(isImage) ? 'images' : 'videos'}/$mediaId');
    Media result = Media.fromJson(json: response.data, datasetId: datasetId);
    return result;
  }

  /// Delete a [Media].
  Future<bool> deleteMedia(
      {required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId,
    bool isImage = true}) async {
    Response response = await delete(
        '/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/${(isImage) ? 'images' : 'videos'}/$mediaId');
    return response.statusCode! == 200;
  }

  /// Download full [Media] image.
  Future<Uint8List> getFullImage({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId
  }) async {
    Response response = await getImage('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/images/$mediaId/display/full');
    return response.data! as Uint8List;
  }

  /// Download the thumbnail of [Media].
  Future<Uint8List> getThumbnailMedia({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId,
    bool isImage = true 
  }) async {
    Response response = await getImage('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/${(isImage) ? 'images' : 'videos'}/$mediaId/display/thumb');
    return response.data! as Uint8List;
  }

  /// Upload a [Media] video.
  Future<Media> uploadVideo({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required Uint8List video,
    String filename = 'sample.mp4' 
  }) async {
    FormData data = FormData.fromMap({
      'file': MultipartFile.fromBytes(video,
          filename: filename, contentType: MediaType('video', filename.split('.').last))
    });
    Response response = await post(
        '/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/videos',
        data);
    Media result = Media.fromJson(json: response.data, datasetId: datasetId);
    return result;
  }

  /// Download video stream
  /// 
  /// TODO - Implementation in the future
  void downloadVideoStream() {}

  /// Download a frame from [Media] video.
  Future<Uint8List> getFullFrameImage({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId,
    required int frameIndex
  }) async {
    Response response = await getImage('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/videos/$mediaId/frames/$frameIndex/display/full');
    return response.data! as Uint8List;
  }

  /// Download a thumbnail for a frame in [Media] video.
  Future<Uint8List> getThumbnailFrameImage({
    required String workspaceId,
    required String projectId,
    required String datasetId,
    required String mediaId,
    required int frameIndex
  }) async {
    Response response = await getImage('/workspaces/$workspaceId/projects/$projectId/datasets/$datasetId/media/videos/$mediaId/frames/$frameIndex/display/thumb');
    return response.data! as Uint8List;
  }
}
