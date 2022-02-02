import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:gffft/users/models/user.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.user, required this.loadData}) : super(key: key);

  final User? user;
  final VoidCallback loadData;

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
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
              if (user == null) {
                VxNavigator.of(context).waitAndPush(Uri(path: LoginScreen.webPath)).then((value) => loadData());
              } else {
                VxNavigator.of(context)
                    .waitAndPush(Uri(pathSegments: ["users", "me", "gfffts", "default"]))
                    .then((value) => loadData());
              }
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
                            l10n!.host,
                            style: const TextStyle(fontFamily: 'SharpieStylie', color: Colors.yellow, fontSize: 60),
                          ),
                        ),
                      )
                    ])),
              ],
            )));
  }
}
