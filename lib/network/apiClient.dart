import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../common/commonWidget.dart';

// This is Common Class for Api Call Code
class ApiCallMethods {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/";
  static const String posts = "posts";
  static const String users = "users";

  //Function For Check Internet is connected or not with wifi or Mobile Network
  static checkInternet() async {
    try {
      if (kIsWeb) {
        return true;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      throw ApiException("Check your internet", "");
    } on SocketException catch (_) {
      throw ApiException("Check your internet", "");
    }
  }

  //This Function for create add all headers if we need while call api
  static getHeaders() {
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    return headers;
  }

  //This function for calling the api with http post
  static Future<http.Response> httpRequest({
    required String url,
    var data,
    bool methodType = true,
  }) async {
    printText("Request Url---------------------$url");
    log("Request url---------------------$url");
    log("Request body---------------------$data");
    if (methodType) {
      return await http.post(Uri.parse("$baseUrl$url"),
          body: data,
          headers: Map<String, String>.from(getHeaders()),
          encoding: utf8);
    } else {
      return await http.get(Uri.parse("$baseUrl$url"));
    }
  }

  static Future<http.Response> post({
    required String url,
    var data,
  }) async {
    await checkInternet();
    return httpRequest(url: url, data: data).timeout(Duration(seconds: 15),
        onTimeout: () => throw TimeoutException("Connection time out"));
  }

  static Future<http.Response> get({
    required String url,
  }) async {
    await checkInternet();
    return httpRequest(url: url, methodType: false);
  }

  // This Function is create for check Response and manage According to us
  static checkResponse({required http.Response response}) {
    printText("Url---------------------${response.request!.url}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ApiException(response.reasonPhrase, "");
    }
  }
}

class ApiException implements Exception {
  final dynamic _message;
  final dynamic _prefix;

  ApiException(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}
