import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/screens/login_screen.dart';

class MeScreen extends StatelessWidget {
  static const String id = 'Me';

  @override
  Widget build(BuildContext context) {
    var i10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    FirebaseAuth fbAuth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(i10n!.me),
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
              onPressed: () =>
                  {fbAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, LoginScreen.id))},
              child: Text(i10n.logout))
        ],
      )),
    );
  }
}
