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

    if (user == null) {
      return Center(
          child: TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
        onPressed: () {
          VxNavigator.of(context).waitAndPush(Uri(path: LoginScreen.webPath)).then((value) => loadData());
        },
        child: Text("login or create account"),
      ));
    }

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        color: theme.backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: Color(0xFF9970A9),
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              VxNavigator.of(context).waitAndPush(Uri(pathSegments: ["users", "me"])).then((value) => loadData());
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                    width: double.infinity,
                    child: Container(
                        child: Text(
                      user!.username,
                      style: theme.textTheme.headline4,
                    ))))));
  }
}
