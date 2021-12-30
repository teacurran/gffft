import 'package:flutter/cupertino.dart';

class ErrorLogger {
  void logError(FlutterErrorDetails details) async {
    //FlutterError.dumpErrorToConsole(details);
    _sendToServer(details.exceptionAsString(), details.stack.toString());
  }

  Future<void> log(Object data, StackTrace stackTrace) async {
    print(data);
    // print(stackTrace);
    //_sendToServer(data.toString(), stackTrace.toString());
  }

  void _sendToServer(String a, String b) async {
    // Implementation here
  }
}
