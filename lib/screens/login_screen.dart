import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login';

  String logoAsset = 'assets/logo.svg';

  Widget getHeaderBuilder(BuildContext context, BoxConstraints constraints, double shrinkOffset) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SvgPicture.asset(logoAsset, semanticsLabel: 'Gffft Logo', color: Theme.of(context).primaryColor),
    );
  }

  Widget getSidebarBuilder(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SvgPicture.asset(logoAsset, semanticsLabel: 'Gffft Logo', color: Theme.of(context).primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(headerBuilder: getHeaderBuilder, sideBuilder: getSidebarBuilder, providerConfigs: const [
      EmailProviderConfiguration(),
      PhoneProviderConfiguration(),
      GoogleProviderConfiguration(
        clientId: '248661822187-jvr2o1rcpqum58u5rcbqgrha1b5segl3.apps.googleusercontent.com',
      ),
    ], actions: [
      AuthStateChangeAction<SignedIn>((context, _) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.id);
      }),
      SignedOutAction((context) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.id);
      })
    ]);
  }
}
