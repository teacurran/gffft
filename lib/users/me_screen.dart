import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';

import '../common/dates.dart';
import '../screens/login_screen.dart';
import 'models/user.dart';

final getIt = GetIt.instance;

class MeScreen extends StatefulWidget {
  static const String webPath = '/users/me';

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  UserApi userApi = getIt<UserApi>();
  Future<User?>? user;
  fba.FirebaseAuth fbAuth = fba.FirebaseAuth.instance;

  Future<void> _loadData() async {
    setState(() {
      user = userApi.me();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          Widget screenBody = const LoadingIndicator(size: 30, borderWidth: 1);

          if (snapshot.hasError) {
            // Navigator.pushReplacementNamed(context, LoginScreen.webPath);
            // Future.delayed(Duration.zero, () async {
            //   VxNavigator.of(context).clearAndPush(Uri(path: LoginScreen.webPath));
            // });
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var user = snapshot.data;
            if (user != null) {
              screenBody = getMeScreen(context, user);
            } else {
              screenBody = LoginScreen(loginStateChanged: _loadData);
            }
          }

          return screenBody;
        });
  }

  Widget getMeScreen(BuildContext context, User user) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.me,
          style: theme.textTheme.headline1,
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Card(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                    color: Color(0xFF9970A9),
                    width: 1.0,
                  )),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                      width: double.infinity,
                      child: Column(children: [
                        SelectableText(l10n.loggedIn),
                        SelectableText(
                          l10n.homeAccountSince(formatDateTime(user.createdAt)),
                          style: theme.textTheme.headline6,
                        )
                      ])))),
          TextButton(onPressed: () => {fbAuth.signOut().then((value) => _loadData())}, child: Text(l10n.logout))
        ],
      )),
    );
  }
}
