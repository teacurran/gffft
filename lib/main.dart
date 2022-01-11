import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/screens/home_screen.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:gffft/style/letter_spacing.dart';
import 'package:gffft/users/me_screen.dart';
import 'package:gffft/users/user_api.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:window_location_href/window_location_href.dart';

import 'boards/board_api.dart';
import 'firebase_options.dart';
import 'gfffts/gffft_api.dart';
import 'gfffts/gffft_home_screen.dart';
import 'gfffts/gffft_list_screen.dart';
import 'gfffts/gffft_screen.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Vx.setPathUrlStrategy();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp(options: firebaseOptions);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (dotenv.get("EMULATE_FIRESTORE", fallback: "false") == "true") {
    FirebaseFirestore.instance.settings = Settings(
        host: dotenv.get('FIRESTORE_HOST', fallback: 'localhost:8080'), sslEnabled: false, persistenceEnabled: true);
  }

  if (dotenv.get("EMULATE_AUTH", fallback: "false") == "true") {
    if (kDebugMode) {
      print('using emulated firebase auth at: localhost, port: 9099');
    }
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  getIt.registerSingleton<BoardApi>(BoardApi());
  getIt.registerSingleton<GffftApi>(GffftApi());
  getIt.registerSingleton<UserApi>(UserApi());
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final navigator = VxNavigator(
      notFoundPage: (uri, params) => MaterialPage(
            key: ValueKey('not-found-page'),
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Page ${uri.path} not found'),
                ),
              ),
            ),
          ),
      routes: {
        "/": (uri, params) => MaterialPage(child: HomeScreen()),
        HomeScreen.webPath: (uri, params) {
          if (FirebaseAuth.instance.currentUser != null) {
            return MaterialPage(child: HomeScreen());
          }
          return MaterialPage(child: LoginScreen());
        },
        GffftListScreen.id: (uri, params) => const MaterialPage(child: GffftListScreen()),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+$"): (uri, param) =>
            MaterialPage(child: GffftHomeScreen(uid: uri.pathSegments[1], gid: uri.pathSegments[3])),
        GffftScreen.webPath: (uri, params) => MaterialPage(child: GffftScreen()),
        LoginScreen.webPath: (uri, params) => MaterialPage(child: LoginScreen()),
        MeScreen.id: (uri, params) => MaterialPage(child: MeScreen()),
      });

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
        brightness: Brightness.light,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(),
    );
  }

  Widget authenticationGate(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;
          var initialRoute = snapshot.hasData && user != null ? HomeScreen.webPath : LoginScreen.webPath;

          return MaterialApp.router(
            title: 'VxNavigator',
            routerDelegate: navigator,
            routeInformationParser: VxInformationParser(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              CountryLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('es', ''), // Spanish
              Locale('pt', ''), // Portugese
            ],
            darkTheme: _buildTheme(context),
            theme: _buildTheme(context),
            themeMode: ThemeMode.dark,
          );
          // show your app’s home page after login
        },
      );

  OutlinedButtonThemeData _getOutlineButtonThemeData(context) {
    return OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ).copyWith(side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(
            color: Colors.yellow,
            width: 1,
          );
        } else {
          return const BorderSide(
            color: Color(0xFF1C839E),
            width: 1,
          );
        }
      },
    )));
  }

  TextButtonThemeData _getTextButtonThemeData(context) {
    return TextButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ).copyWith(side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(
            color: Colors.yellow,
            width: 1,
          );
        } else {
          return const BorderSide(
            color: Color(0xFF1C839E),
            width: 1,
          );
        }
      },
    )));
  }

  ThemeData _buildTheme(context) {
    final base = ThemeData.dark();
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(0xFF33333D),
        elevation: 0,
      ),
      errorColor: const Color(0xFFFF206B),
      scaffoldBackgroundColor: const Color(0xFF33333D),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.blue),
      outlinedButtonTheme: _getOutlineButtonThemeData(context),
      textButtonTheme: _getTextButtonThemeData(context),
      backgroundColor: const Color(0xFF323436),
      primaryColor: const Color(0xFF1C839E),
      secondaryHeaderColor: Colors.white,
      primaryColorDark: Colors.black,
      primaryColorLight: const Color(0xFF9970A9),
      focusColor: const Color(0xCCFFFFFF),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.lightBlue[50]), // app header text
      ),
      inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.w500,
          ),
          isDense: false,
          contentPadding: EdgeInsets.all(5),
          filled: false,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF935D5D), width: 1.0),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF935D5D), width: 1.0),
          ),
          fillColor: Color(0xFFE0E2E2),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purpleAccent, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 1.0),
          )),
      visualDensity: VisualDensity.standard,
      cardColor: Colors.black12,
      dialogBackgroundColor: Colors.white,
      shadowColor: Colors.grey,
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        )
        .copyWith(
          bodyText1: GoogleFonts.robotoCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
          ),
          bodyText2: GoogleFonts.robotoCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
            color: Colors.lightGreen,
          ),
          button: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacingOrNone(2.8),
            color: Colors.lightBlue[200],
          ),
          headline1: const TextStyle(color: Color(0xFF1C839E), fontSize: 40),
          headline4: GoogleFonts.robotoCondensed(color: Colors.lightGreenAccent),
          headline5: GoogleFonts.robotoCondensed(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
          subtitle1: TextStyle(color: Colors.lightGreenAccent), // input text
          headline6: TextStyle(color: Colors.white),
        );
  }
}
