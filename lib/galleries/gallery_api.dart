import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api_base.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class GalleryApi extends ApiBase {
  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()..connectionTimeout = const Duration(seconds: 120);
    return httpClient;
  }

  Future<void> uploadGalleryItem(String uid, String gid, String mid, String description, XFile file,
      {OnUploadProgressCallback? onUploadProgress}) async {
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    var url = Uri.parse(getBaseUrl() + "galleries");
    if (kDebugMode) {
      print('Posting gallery item, url $url');
    }

    String? responseJson;
    try {
      final httpClient = getHttpClient();
      final request = await httpClient.postUrl(url);

      // this method always requires auth
      if (fbAuth.currentUser == null) {
        throw FetchDataException('User must be authenticated');
      } else {
        final String token = await fbAuth.currentUser!.getIdToken(false);
        if (kDebugMode) {
          print('auth token: $token');
        }
        request.headers.set("Authorization", "Bearer $token");
      }

      final requestMultipart = http.MultipartRequest("POST", url);

      var image = http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.name);
      requestMultipart.files.add(image);
      requestMultipart.fields['uid'] = uid;
      requestMultipart.fields['gid'] = gid;
      requestMultipart.fields['mid'] = mid;
      requestMultipart.fields['description'] = description;

      var msStream = requestMultipart.finalize();
      var totalByteLength = requestMultipart.contentLength;

      var multipartContentType = requestMultipart.headers[HttpHeaders.contentTypeHeader];
      if (multipartContentType != null) {
        request.headers.set(HttpHeaders.contentTypeHeader, multipartContentType);
      }

      request.contentLength = totalByteLength;
      int byteCount = 0;
      Stream<List<int>> streamUpload = msStream.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            byteCount += data.length;

            if (onUploadProgress != null) {
              onUploadProgress(byteCount, totalByteLength);
            }

            sink.add(data);
          },
          handleError: (error, stack, sink) {
            print(error.toString());
          },
          handleDone: (sink) {
            sink.close();
            // UPLOAD DONE;
          },
        ),
      );

      // var image = http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.name);

      await request.addStream(streamUpload);

      //final streamedResponse = await request.send();
      // var response = await http.Response.fromStream(streamedResponse);

      final response = await request.close();

      if (response.statusCode == 403) {
        await fbAuth.signOut();
      }
      //responseJson = await returnResponseFromClient(response);
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
    //return responseJson;
  }
}
