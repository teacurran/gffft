import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ApiResponse<T> {
  Status status;

  T? data;

  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

class ApiBase {
  final String _baseUrl = "https://us-central1-gffft-auth.cloudfunctions.net/api/";

  final headers = <String, String>{};
  Future<dynamic> get(String url) async {
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    if (kDebugMode) {
      print('Api Get, url $url');
    }
    var responseJson;
    try {
      final request = http.Request("get", (Uri.parse(_baseUrl + url)));
      if (fbAuth.currentUser != null) {
        final String token = await fbAuth.currentUser!.getIdToken(false);
        request.headers.addAll({
          "Authorization": "Bearer $token",
        });
      }

      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAuthenticated(String url) async {
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    if (kDebugMode) {
      print('Api Get, url $url');
    }
    var responseJson;
    try {
      final request = http.Request("get", (Uri.parse(_baseUrl + url)));
      if (fbAuth.currentUser == null) {
        throw FetchDataException('User must be authenticated');
      } else {
        final String token = await fbAuth.currentUser!.getIdToken(false);
        request.headers.addAll({
          "Authorization": "Bearer $token",
        });
      }

      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
