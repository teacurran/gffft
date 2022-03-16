import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';

class LoginScreen extends StatefulWidget {
  static const String webPath = '/login';
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;

  const LoginScreen({Key? key, this.onLogin, this.onLogout}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String logoAsset = 'assets/logo.svg';

  Widget getHeaderBuilder(BuildContext context, BoxConstraints constraints, double shrinkOffset) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SvgPicture.asset(logoAsset, semanticsLabel: 'Gffft Logo', color: const Color(0xFF1C839E)),
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
    var maxExtent = 50.0;
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      maxExtent = 0;
    }

    // always 0 for now
    maxExtent = 0;

    return SignInScreen(
        headerBuilder: getHeaderBuilder,
        headerMaxExtent: maxExtent,
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
            if (widget.onLogin != null) {
              widget.onLogin!();
            }
          }),
          SignedOutAction((context) {
            if (widget.onLogout != null) {
              widget.onLogout!();
            }
          })
        ]);
  }
}
