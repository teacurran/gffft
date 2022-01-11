import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class MeScreen extends StatelessWidget {
  static const String webPath = 'users/me';

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n!.me),
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          TextButton(
              onPressed: () => {VxNavigator.of(context).replace(Uri(path: LoginScreen.webPath))},
              // {fbAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, LoginScreen.webPath))},
              child: Text(l10n.logout))
        ],
      )),
    );
  }
}
