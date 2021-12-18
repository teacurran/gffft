import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/src/constants.dart';
import 'package:gffft/user/user.dart';
import 'package:gffft/user/user_api.dart';

final getIt = GetIt.instance;

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  UserApi userApi = getIt<UserApi>();
  User? user;

  @override
  void initState() {
    super.initState();
  }

  Future<User?> _init(context) async {
    user ??= await userApi.me();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init(context),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("error loading user info."));
          }
          var data = snapshot.data;
          String text = Constants.thankYou + ":" + (data != null ? data.id + ":" + data.username : "unknown user");
          return Center(child: Text(text));
        });
  }
}
