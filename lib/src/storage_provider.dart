import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Used to store and retrieve the user email address and phone
class StorageProvider {
  StorageProvider({required this.flutterSecureStorage}) : assert(flutterSecureStorage != null);

  final FlutterSecureStorage flutterSecureStorage;

  static const String storageUserEmailKey = 'userEmailAddress';

  // email
  Future<void> setEmail(String email) async {
    if (kDebugMode) print("setting email to:${email}");
    await flutterSecureStorage.write(key: storageUserEmailKey, value: email);
  }

  Future<void> clearEmail() async {
    await flutterSecureStorage.delete(key: storageUserEmailKey);
  }

  Future<String?> getEmail() async {
    String? email = await flutterSecureStorage.read(key: storageUserEmailKey);
    if (kDebugMode) print("get email to:$email");
    return email;
  }
}
