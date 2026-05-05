import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  dynamic responseJson;


  Future<dynamic> getapi(String url) async {
    if(kDebugMode){
      log("url: $url");

    }

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);
    } on SocketException {
      throw InternetException();
    } on RequestTimeOutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }

    return responseJson;
  }

  Future<dynamic> postapi(var data, String url) async {

    if(kDebugMode){
      log("url: $url");
      log("data: $data");
    }

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(data),
        headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnresponse(response);

    } on SocketException {
      throw InternetException();
    } on RequestTimeOutException {
      throw RequestTimeOutException();
    } on HttpException {
      throw ServerException();
    }

    return responseJson;
  }



  dynamic returnresponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());

      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code ${response
                .statusCode}");
    }
  }
}
