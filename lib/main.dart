import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/screens/app_screen.dart';
import 'package:gffft/user/user_api.dart';
import 'package:window_location_href/window_location_href.dart';

import 'firebase_options.dart';

final getIt = GetIt.instance;
const String logoAsset = kIsWeb ? 'logo.svg' : 'assets/logo.svg';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  getIt.registerSingleton<UserApi>(UserApi());
  runApp(App());
}

class App extends StatelessWidget {
  Future<void> _init(context) async {
    // http://localhost:59282/?link=https://gffft-auth.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyASr9Mp4VFSzFVAbDnuj_mAsrcX_oAI8jw%26mode%3DsignIn%26oobCode%3DPpqQPHEigxWAPHm9YL55XRySmgtfNedqRtum0YcAfJwAAAF9fvzgvA%26continueUrl%3Dhttp://localhost/links/home%26lang%3Den&apn=com.approachingpi.gffft&amv=21&ibi=com.approachingpi.gffft&ifl=https://gffft-auth.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyASr9Mp4VFSzFVAbDnuj_mAsrcX_oAI8jw%26mode%3DsignIn%26oobCode%3DPpqQPHEigxWAPHm9YL55XRySmgtfNedqRtum0YcAfJwAAAF9fvzgvA%26continueUrl%3Dhttp://localhost/links/home%26lang%3Den
    // var _auth = Provider.of<AuthModel>(context);
    //var _auth = AuthModel();

    String? deepLink;
    if (kIsWeb) {
      deepLink = getHref();
    } else {
      deepLink = getHref();
    }

    //window.location.
    // if (deepLink != null) {
    //   if (await _auth.isSignInWithEmailLink(deepLink)) {
    //     _auth.signInWithEmailLink(deepLink);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _init(context),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return loadingScreen(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return authenticationGate(context);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loadingScreen(context);
      },
    );
  }

  Widget loadingScreen(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        highlightColor: Colors.teal,
        primaryColor: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(),
    );
  }

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

  Widget authenticationGate(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;
          var initialRoute = snapshot.hasData && user != null ? '/home' : '/login';

          return MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                CountryLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
                Locale('es', ''), // Spanish, no country code
              ],
              initialRoute: initialRoute,
              routes: {
                '/home': (context) => AppScreen(),
                '/login': (context) => SignInScreen(
                        headerBuilder: getHeaderBuilder,
                        sideBuilder: getSidebarBuilder,
                        providerConfigs: const [
                          EmailProviderConfiguration(),
                          PhoneProviderConfiguration(),
                          GoogleProviderConfiguration(
                            clientId: '248661822187-jvr2o1rcpqum58u5rcbqgrha1b5segl3.apps.googleusercontent.com',
                          ),
                        ],
                        actions: [
                          AuthStateChangeAction<SignedIn>((context, _) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          }),
                          SignedOutAction((context) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          })
                        ]),
              },
              theme: ThemeData(
                highlightColor: Colors.deepPurple,
                primaryColor: Colors.blue,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                highlightColor: Colors.deepPurple,
                primaryColor: Colors.blue,
                backgroundColor: Colors.black12,
                /* dark theme settings */
              ),
              themeMode: ThemeMode.dark);
          // show your app’s home page after login
        },
      );
}
