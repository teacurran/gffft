import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/home/host_card.dart';
import 'package:gffft/home/profile_card.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/connect_screen.dart';
import 'package:gffft/users/models/user.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

final getIt = GetIt.instance;
const String logoAsset = 'assets/logo.svg';

class HomeScreen extends StatefulWidget {
  static const String webPath = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserApi userApi = getIt<UserApi>();
  Future<User?>? user;

  Future<void> _loadData() async {
    user = userApi.me().onError((error, stackTrace) async {
      await fbAuth.FirebaseAuth.instance.signOut();
      if (kDebugMode) {
        print("error getting me, token expired?");
      }
      return null;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return StreamBuilder<fbAuth.User?>(
      stream: fbAuth.FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) => FutureBuilder(
          future: user,
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasError) {
              // Navigator.pushReplacementNamed(context, LoginScreen.webPath);
              // Future.delayed(Duration.zero, () async {
              //   VxNavigator.of(context).clearAndPush(Uri(path: LoginScreen.webPath));
              // });
              return (SelectableText("error: ${snapshot.error.toString()}"));
            }

            var user = snapshot.data;

            return SafeArea(
                child: Scaffold(
                    body: RefreshIndicator(
                        onRefresh: _loadData,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: SvgPicture.asset(logoAsset,
                                      semanticsLabel: 'Gffft Logo', color: theme.primaryColor, height: 150)),
                              Card(
                                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                                  color: theme.backgroundColor,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Color(0xFFB56277),
                                        width: 1.0,
                                      )),
                                  child: InkWell(
                                      onTap: () {
                                        VxNavigator.of(context).push(Uri(path: ConnectScreen.webPath));
                                      },
                                      splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                                      // Generally, material cards do not have a highlight overlay.
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                                                child: Text(l10n!.connect,
                                                    style: const TextStyle(
                                                        fontFamily: 'ElectroCandy',
                                                        color: Colors.yellow,
                                                        fontSize: 60))),
                                          ),
                                        ],
                                      ))),
                              if (user != null) HostCard(user: user, loadData: _loadData),
                              ProfileCard(user: user, loadData: _loadData)
                            ],
                          ),
                        ))));
          }),
    );
  }
}
