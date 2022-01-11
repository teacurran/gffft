import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/gffft_list_screen.dart';
import 'package:gffft/gfffts/gffft_screen.dart';
import 'package:gffft/users/me_screen.dart';
import 'package:gffft/users/user.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

final getIt = GetIt.instance;
const String logoAsset = 'assets/logo.svg';

class HomeScreen extends StatefulWidget {
  static const String webPath = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserApi userApi = getIt<UserApi>();
  Future<User>? user;

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

    final textStyle = theme.textTheme.bodyText1 ?? const TextStyle();

    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            // Navigator.pushReplacementNamed(context, LoginScreen.webPath);
            // VxNavigator.of(context).push(Uri(path: LoginScreen.webPath));
          }

          var user = snapshot.data;
          String text;
          String? boardId;
          if (user == null) {
            text = l10n!.loading;
            boardId = l10n.loading;
          } else {
            text = "Thank You: ${user.username}";
            if (user.board != null) {
              boardId = user.board!.id;
            }
          }

          var username = user == null ? l10n!.loading : user.username;

          return SafeArea(
              child: Scaffold(
                  body: RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
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
                                      color: Color(0xFF9970A9),
                                      width: 1.0,
                                    )),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, MeScreen.id);
                                    },
                                    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                                    highlightColor: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                                              child: Text(
                                                username,
                                                style: theme.textTheme.headline4,
                                              ),
                                            )),
                                      ],
                                    ))),
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
                                      VxNavigator.of(context).push(Uri(path: GffftListScreen.id));
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
                                              child: Text(
                                                l10n!.connect,
                                                style: theme.textTheme.headline4,
                                              )),
                                        ),
                                      ],
                                    ))),
                            Card(
                                margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                                color: theme.backgroundColor,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Color(0xFF00829C),
                                      width: 1.0,
                                    )),
                                child: InkWell(
                                    onTap: () {
                                      VxNavigator.of(context).push(Uri(path: GffftScreen.webPath));
                                    },
                                    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                                    // Generally, material cards do not have a highlight overlay.
                                    highlightColor: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 100,
                                            child: Stack(children: [
                                              Positioned(
                                                top: 16,
                                                left: 16,
                                                right: 16,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    l10n.host,
                                                    style: const TextStyle(
                                                        fontFamily: 'DoubleFeature',
                                                        color: Colors.yellow,
                                                        fontSize: 60),
                                                  ),
                                                ),
                                              )
                                            ])),
                                      ],
                                    ))),
                          ],
                        ),
                      ))));
        });
  }
}
