import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:velocity_x/velocity_x.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String webPath = '/login';

  String logoAsset = 'assets/logo.png';

  Widget getHeaderBuilder(BuildContext context, BoxConstraints constraints, double shrinkOffset) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Image(image: AssetImage(logoAsset), semanticLabel: 'Gffft Logo'),
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
    return SignInScreen(
        headerBuilder: getHeaderBuilder,
        headerMaxExtent: 150,
        sideBuilder: getSidebarBuilder,
        providerConfigs: const [
          EmailProviderConfiguration(),
          PhoneProviderConfiguration(),
          /*
      GoogleProviderConfiguration(
        clientId: '248661822187-jvr2o1rcpqum58u5rcbqgrha1b5segl3.apps.googleusercontent.com',
      ),
       */
        ],
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) {
            VxNavigator.of(context).push(Uri(path: HomeScreen.webPath));
          }),
          SignedOutAction((context) {
            VxNavigator.of(context).push(Uri(path: LoginScreen.webPath));
          })
        ]);
  }
}
