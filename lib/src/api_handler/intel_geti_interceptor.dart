import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

/// Interceptor for Intel GETi
/// 
/// It is advised to create your custom [Interceptor]
/// by extending [IntelGetiInterceptor] and overriding
/// the three functions below.
/// [onRequest] is called before a request is sent out.
/// [onResponse] is called before a response arrives for evaluation.
/// [onError] is called before an error response arrives for evaluation.
class IntelGetiInterceptor extends Interceptor {
  CookieJar cookieJar;

  IntelGetiInterceptor({required this.cookieJar}) : super();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Disable auto redirect following
    options.followRedirects = false;
    // Handle attaching cookie
    cookieJar.loadForRequest(options.uri)
    .then((cookies) {
      cookies = cookies.where((cookie) => !cookie.expires!.isBefore(DateTime.now())).toList();
      for (var cookie in cookies) {
        options.headers[HttpHeaders.cookieHeader] = cookie;
      }
    })
    .catchError((error){
      print (error);
    })
    .whenComplete(() {
      super.onRequest(options, handler);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers.map.containsKey(HttpHeaders.setCookieHeader)){
      List<Cookie> cookies = [];
      for (var cookieString in response.headers.map[HttpHeaders.setCookieHeader]!) {
        cookies.add(Cookie.fromSetCookieValue(cookieString));
      }
      cookieJar.saveFromResponse(Uri.https(response.realUri.host, ''), cookies);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) => super.onError(err, handler);
}