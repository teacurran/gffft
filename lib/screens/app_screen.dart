import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/src/constants.dart';
import 'package:gffft/users/user.dart';
import 'package:gffft/users/user_api.dart';

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
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.headline5 ?? const TextStyle();
    final textStyle = theme.textTheme.bodyText1 ?? const TextStyle();
    final descriptionStyle = theme.textTheme.subtitle1;

    return FutureBuilder(
        future: _init(context),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(i10n!.errorLoading));
          }

          var user = snapshot.data;
          String text;
          String? boardId;
          if (user == null) {
            text = i10n!.loading;
            boardId = i10n.loading;
          } else {
            text = Constants.thankYou + ":" + user.username;
            if (user.board != null) {
              boardId = user.board!.id;
            }
          }

          var username = user == null ? i10n!.loading : user.username;

          return SafeArea(
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
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    color: theme.primaryColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/me');
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
                                    username,
                                    style: theme.textTheme.headline4,
                                  ),
                                )),
                          ],
                        ))),
                Card(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    color: theme.primaryColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/connect');
                        },
                        splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                        // Generally, material cards do not have a highlight overlay.
                        highlightColor: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 150,
                                child: Stack(children: [
                                  Positioned.fill(
                                    // In order to have the ink splash appear above the image, you
                                    // must use Ink.image. This allows the image to be painted as
                                    // part of the Material and display ink effects above it. Using
                                    // a standard Image will obscure the ink splash.
                                    child: Ink.image(
                                      image: const AssetImage('assets/antenna-farm.jpg'),
                                      fit: BoxFit.cover,
                                      child: Container(),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        i10n!.connect,
                                        style: theme.textTheme.headline4,
                                      ),
                                    ),
                                  )
                                ])),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: DefaultTextStyle(
                                style: textStyle,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // This array contains the three line description on each card
                                    // demo.
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        "line 1 of text",
                                        style: theme.textTheme.bodyText1,
                                      ),
                                    ),
                                    Text("line 2 of text"),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "line 3 of text with bottom padding",
                                        style: theme.textTheme.bodyText1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
                Card(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    color: theme.primaryColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/host');
                        },
                        splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                        // Generally, material cards do not have a highlight overlay.
                        highlightColor: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 150,
                                child: Stack(children: [
                                  Positioned.fill(
                                    // In order to have the ink splash appear above the image, you
                                    // must use Ink.image. This allows the image to be painted as
                                    // part of the Material and display ink effects above it. Using
                                    // a standard Image will obscure the ink splash.
                                    child: Ink.image(
                                      image: const AssetImage('assets/hayes.jpg'),
                                      fit: BoxFit.cover,
                                      child: Container(),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        i10n.host,
                                        style: theme.textTheme.headline4,
                                      ),
                                    ),
                                  )
                                ])),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: DefaultTextStyle(
                                style: textStyle,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // This array contains the three line description on each card
                                    // demo.
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        "destination.description",
                                        style: theme.textTheme.bodyText1,
                                      ),
                                    ),
                                    Text("id: ${boardId}"),
                                    Text("destination.location"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))),
              ],
            ),
          ));
        });
  }
}
