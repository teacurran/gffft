import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/user.dart';

final getIt = GetIt.instance;

class MeScreen extends StatefulWidget {
  static const String webPath = 'users/me';

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
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            // Navigator.pushReplacementNamed(context, LoginScreen.webPath);
            Future.delayed(Duration.zero, () async {
              VxNavigator.of(context).clearAndPush(Uri(path: LoginScreen.webPath));
            });
          }

          var user = snapshot.data;
          String text;
          if (user == null) {
            text = l10n!.loading;
          } else {
            text = "Thank You: ${user.username}";
          }

          var username = user == null ? l10n!.loading : user.username;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                l10n!.me,
                style: theme.textTheme.headline1,
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                onPressed: () => VxNavigator.of(context).returnAndPush(true),
              ),
              centerTitle: true,
            ),
            body: Center(
                child: Column(
              children: [
                Card(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                    color: theme.backgroundColor,
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
                            child: Container(
                                child: Text(
                              username,
                              style: theme.textTheme.headline4,
                            ))))),
                TextButton(
                    onPressed: () => {userApi.changeUsername().then((value) => _loadData())},
                    // {fbAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, LoginScreen.webPath))},
                    child: Text(l10n.changeUsername)),
                TextButton(
                    onPressed: () => {
                          fbAuth
                              .signOut()
                              .then((value) => VxNavigator.of(context).replace(Uri(path: LoginScreen.webPath)))
                        },
                    child: Text(l10n.logout))
              ],
            )),
          );
        });
  }
}
