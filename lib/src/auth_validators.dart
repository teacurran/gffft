import 'dart:async';
import 'package:gffft/src/constants.dart';

class AuthValidators {
  final validateEmail =
  StreamTransformer.fromHandlers(handleData: (String email, EventSink<String> sink) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError(Constants.errorEmail);
    }
  });

  final validatePhone =
  StreamTransformer.fromHandlers(handleData: (String phone, EventSink<String> sink) {
    if (RegExp(r"^(?:[+0]+)?[0-9]{6,14}$").hasMatch(phone)) {
      sink.add(phone);
    } else {
      sink.addError(Constants.errorPhone);
    }
  });
}