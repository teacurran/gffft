import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api_base.dart';

class GalleryApi extends ApiBase {
  Future<void> uploadGalleryItem(String uid, String gid, String mid, XFile file) async {
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    var url = Uri.parse(getBaseUrl() + "galleries");
    if (kDebugMode) {
      print('Posting gallery item, url $url');
    }

    dynamic responseJson;
    try {
      final request = http.MultipartRequest("POST", url);

      // this method always requires auth
      if (fbAuth.currentUser == null) {
        throw FetchDataException('User must be authenticated');
      } else {
        final String token = await fbAuth.currentUser!.getIdToken(false);
        if (kDebugMode) {
          print('auth token: $token');
        }
        request.headers.addAll({
          "Authorization": "Bearer $token",
        });
      }

      var image = http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.name);
      request.files.add(image);

      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 403) {
        await fbAuth.signOut();
      }
      responseJson = returnResponse(response);
    } catch (e, stacktrace) {
      if (e is SocketException) {
        //treat SocketException
        if (kDebugMode) {
          print("Socket exception: ${e.toString()}");
        }
      } else if (e is TimeoutException) {
        //treat TimeoutException
        if (kDebugMode) {
          print("Timeout exception: ${e.toString()}");
        }
      } else if (kDebugMode) {
        print("Unhandled exception. signing user out.: ${e.toString()}");
        //await fbAuth.signOut();
      }

      // await FirebaseCrashlytics.instance
      //     .recordError(e, stacktrace, reason: 'API call failed: ${url}, payload: ${payload}');

      throw FetchDataException('Unable to post gallery item');
    }
    return responseJson;
  }
}
