import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/src/constants.dart';
import 'package:gffft/user/user.dart';
import 'package:gffft/user/user_api.dart';

final getIt = GetIt.instance;
const String logoAsset = 'assets/logo.svg';

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
    FirebaseAuth fbAuth = FirebaseAuth.instance;
    var i10n = AppLocalizations.of(context);
    return FutureBuilder(
        future: _init(context),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(i10n!.errorLoading));
          }

          var user = snapshot.data;
          String text;
          if (user == null) {
            text = i10n!.loading;
          } else {
            text = Constants.thankYou + ":" + user.username;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text(text, style: Theme.of(context).primaryTextTheme.bodyText1)),
              SvgPicture.asset(logoAsset, semanticsLabel: 'Gffft Logo', color: Theme.of(context).highlightColor),
              TextButton(
                  onPressed: () =>
                      {fbAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, "/login"))},
                  child: Text("logout"))
            ],
          );
        });
  }
}
