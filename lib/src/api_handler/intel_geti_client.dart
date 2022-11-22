import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:intel_geti_api/intel_geti_api.dart';

/// Client API handler for Intel GETi.
///
/// [IntelGetiClient] is designed to handle most basic functions of Intel GETi with REST API.
/// [apiURL] is currently set to v1.
/// [_dio] is used to handle all HTTP requests and responses.
/// [_cookieJar] contains cookies used for authentication.
/// [isTrustedServer] is a simple safety check done for HTTP servers.
/// [getiServerURL] is the IP address of the GETi server.
/// [userID] is the user id of the GETi user.
///
/// By default [RetryInterceptor], is added to retry up to 3 times when requests fail.
class IntelGetiClient {
  static String apiURL = '/api/v1';
  // Base Dio and cookie jar instance
  final Dio _dio = Dio()
    ..options.headers['connection'] = 'keep-alive'
    ..options.connectTimeout = 1000 * 60 * 2
    ..options.receiveTimeout = 1000 * 60 * 2;
  final CookieJar _cookieJar = CookieJar();

  bool isTrustedServer;
  String getiServerURL;
  String userID;

  /// Constructor for creating an [IntelGetiClient] instance.
  IntelGetiClient(
      {required this.getiServerURL,
      required this.userID,
      this.isTrustedServer = true,
      List<Interceptor> interceptors = const <Interceptor>[]}) {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return (isTrustedServer) ? true : false;
      };
    };
    for (Interceptor interceptor in interceptors) {
      _dio.interceptors.add(interceptor);
    }
    _dio.interceptors.add(IntelGetiInterceptor(cookieJar: cookieJar));
    _dio.interceptors.add(RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3)
        ]));
  }

  /// Add HTTP interceptors.
  void addInterceptors({required Interceptor interceptor}) =>
      _dio.interceptors.add(interceptor);

  /// Delete all cookies.
  ///
  /// This method deletes all cookies within [_cookieJar].
  void emptyCookies() => _cookieJar.deleteAll();

  /// Get cookie jar.
  CookieJar get cookieJar => _cookieJar;

  /// Return initial URL for login.
  ///
  /// This function returns the inital login URL for Intel GETi asynchronously.
  Future<String> _getInitialLoginURL() async {
    Response response = await _dio.get(getiServerURL,
        options: Options(
            validateStatus: ((status) => _validStatusForAuth(status!))));
    Response loginResponse = await _followLoginRedirects(response);
    return loginResponse.realUri.toString();
  }

  /// Return the true login URL after redirects.
  ///
  /// This function returns the true login URL for Intel GETi asynchronously.
  /// Each redirection must be evaluated since Dio registers certain status codes
  /// as errors when using POST
  Future<Response> _followLoginRedirects(Response response) async {
    if (response.headers.map.containsKey('location')) {
      String redirectURL = response.headers.map['location']!.first;
      if (!redirectURL.startsWith('http')) {
        redirectURL = '$getiServerURL$redirectURL';
      }
      Response redirected = await _dio.get(redirectURL,
          options: Options(
              validateStatus: (status) => _validStatusForAuth(status!)));
      return await _followLoginRedirects(redirected);
    } else {
      return response;
    }
  }

  /// Return true if response status code is valid for Intel GETi authentication.
  ///
  /// Thie function returns true if [status] is valid for authentication.
  /// The valid status codes are 200 OK, 302 Redirect Found, and 303 Redirect See Other.
  /// It returns false otherwise.
  bool _validStatusForAuth(int status) => [200, 302, 303].contains(status);

  /// Return [Response] after attempting user authentication with user id and password.
  ///
  /// This function returns [Response] upon successful and unsuccessful login.
  /// It will raise [DioError] when encountering systematic errors.
  Future<bool> authenticate(Map<String, dynamic> data) async {
    // Empty all cookies
    emptyCookies();
    // Special authentication handler for SC.
    String loginPath = await _getInitialLoginURL();
    Response loginResponse = await _dio.post(loginPath,
        data: data,
        options: Options(
            headers: {'content-type': 'application/x-www-form-urlencoded'},
            validateStatus: (status) => _validStatusForAuth(status!)));
    await _followLoginRedirects(loginResponse);
    return (await _cookieJar.loadForRequest(Uri.parse(getiServerURL)))
        .where((Cookie cookie) => cookie.name == '_oauth2_proxy')
        .isNotEmpty;
  }

  /// Return [Response] after GET request.
  Future<Response> get(String path) async =>
      await _dio.get('$getiServerURL$apiURL$path');

  /// Return [Response] after GET request for getting an image.
  Future<Response> getImage(String path) async =>
      await _dio.get('$getiServerURL$apiURL$path',
          options: Options(responseType: ResponseType.bytes));

  /// Return [Response] after GET request for getting an image.
  ///
  /// This function is particularly useful when dealing with getting image data from URL provided by the Intel GETi server.
  /// The image URLs will most likely have [apiURL] already embedded in them.
  /// Thus, this function omits [apiURL] when sending a request.
  Future<Response> getImageWithoutApiUrl(String path) async =>
      await _dio.get('$getiServerURL$path',
          options: Options(responseType: ResponseType.bytes));

  /// Return [Response] after POST request.
  ///
  /// This function takes in [data] which can be either [Map] for JSON or [FormData] for Form Data.
  Future<Response> post(String path, dynamic data) async =>
      await _dio.post('$getiServerURL$apiURL$path', data: data);

  /// Return [Response] after PUT request.
  ///
  /// This function takes in [data] which can be either [Map] for JSON or [FormData] for Form Data.
  Future<Response> put(String path, dynamic data) async =>
      await _dio.put('$getiServerURL$apiURL$path', data: data);

  /// Return [Response] after DELETE request.
  Future<Response> delete(String path) async =>
      await _dio.delete('$getiServerURL$apiURL$path');

  // Settings
  Future<bool> getCurrentAutoTrainingSetting(
      {required String workspaceId,
      required String projectId,
      required String taskId,
      bool? forceSet}) async {
    Response configResponse = await get(
        '/workspaces/$workspaceId/projects/$projectId/configuration/task_chain/$taskId');
    Map payload = configResponse.data;
    int i = (payload['components'] as List)
        .indexWhere((element) => element['header'] == 'General');
    return (payload['components'][i]['parameters'] as List)
        .firstWhere((element) => element['name'] == 'auto_training')['value'];
  }

  Future<Response> postAutoTrainingSetting(
      {required String workspaceId,
      required String projectId,
      required String taskId,
      bool? forceSet}) async {
    void setAutoTraining(Map payload, bool? force) {
      int i = (payload['components'] as List)
          .indexWhere((element) => element['header'] == 'General');
      (payload['components'][i]['parameters'] as List).firstWhere(
          (element) => element['name'] == 'auto_training')['value'] = (force ==
              null)
          ? !((payload['components'][i]['parameters'] as List).firstWhere(
              (element) => element['name'] == 'auto_training')['value'] as bool)
          : force;
      payload.remove('task_id');
      payload.remove('task_title');
    }

    Response configResponse = await get(
        '/workspaces/$workspaceId/projects/$projectId/configuration/task_chain/$taskId');
    Map payload = configResponse.data;
    setAutoTraining(payload, forceSet);
    return await post(
        '/workspaces/$workspaceId/projects/$projectId/configuration/task_chain/$taskId',
        payload);
  }
}
