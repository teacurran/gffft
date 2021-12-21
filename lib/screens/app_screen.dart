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
          if (user == null) {
            text = i10n!.loading;
          } else {
            text = Constants.thankYou + ":" + user.username;
          }
          return SafeArea(
              child: Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   title: Text(i10n?.helloWorld ?? 'test'),
            // ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SvgPicture.asset(logoAsset,
                        semanticsLabel: 'Gffft Logo', color: theme.primaryColor, height: 150)),
                Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: SafeArea(
                        top: false,
                        bottom: false,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                                color: Colors.deepPurple,
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                    onTap: () {},
                                    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
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
                                                  image: const AssetImage('assets/piggy-bank.png'),
                                                  fit: BoxFit.cover,
                                                  child: Container(),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 16,
                                                left: 16,
                                                right: 16,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "destination.title",
                                                    style: theme.textTheme.bodyText1,
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
                                                Text("destination.city"),
                                                Text("destination.location"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )))))),
                Center(child: Text(text, style: Theme.of(context).primaryTextTheme.bodyText1)),
                TextButton(
                    onPressed: () =>
                        {fbAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, "/login"))},
                    child: Text("logout"))
              ],
            ),
          ));
        });
  }
}
