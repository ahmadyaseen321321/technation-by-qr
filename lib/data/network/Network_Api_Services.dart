import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:technation_hub/User_Prefrences/User_Prefrecnes.dart';
import 'package:technation_hub/res/routes/routes_names.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  dynamic responseJson;


  Future<dynamic> getapi(String url, {Map<String, String>? headers}) async {
    if(kDebugMode){
      log("url: $url");
      log("headers: $headers");
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }

    return responseJson;
  }

  Future<dynamic> postapi(var data, String url, {Map<String, String>? headers}) async {

    if(kDebugMode){
      log("url: $url");
      log("data: $data");
    }

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(data),
        headers: headers ?? {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);

    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }

    return responseJson;
  }

  Future<dynamic> patchapi(var data, String url, {Map<String, String>? headers}) async {
    if(kDebugMode){
      log("url: $url");
      log("data: $data");
    }

    try {
      final response = await http.patch(Uri.parse(url),
        body: jsonEncode(data),
        headers: headers ?? {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }

    return responseJson;
  }

  Future<dynamic> deleteapi(String url, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      log("DELETE url: $url");
    }
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ?? {"Accept": "application/json"},
      ).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }
    return responseJson;
  }



  dynamic returnresponse(http.Response response) {
    // Guard against non-JSON responses (e.g. HTML error pages)
    dynamic tryDecodeJson() {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return null;
      }
    }

    String errorMessage(dynamic decoded) {
      if (decoded is Map && decoded['error'] != null) {
        return decoded['error'].toString();
      }
      return response.body.length > 200
          ? 'Server returned an unexpected response'
          : response.body;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        final decoded = tryDecodeJson();
        if (decoded == null) {
          throw FetchDataException(
              'Invalid response from server (status ${response.statusCode})');
        }
        return decoded;
      case 400:
        throw BadRequestException(errorMessage(tryDecodeJson()));
      case 401:
        UserPreferences().removeUser();
        Get.offAllNamed(RouteName.loginScreen);
        throw UnauthorizedException(errorMessage(tryDecodeJson()));
      case 404:
        throw InvalidUrlException('Endpoint not found (404)');
      case 500:
        throw ServerException(errorMessage(tryDecodeJson()));
      default:
        throw FetchDataException(
            'Error communicating with server (status ${response.statusCode})');
    }
  }
}
