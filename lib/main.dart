// @dart=2.14
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_view_screen.dart';
import 'package:gffft/boards/thread_view_screen.dart';
import 'package:gffft/screens/home_screen.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:gffft/style/letter_spacing.dart';
import 'package:gffft/users/bookmark_screen.dart';
import 'package:gffft/users/me_screen.dart';
import 'package:gffft/users/user_api.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:window_location_href/window_location_href.dart';

import 'boards/board_api.dart';
import 'boards/create_post_screen.dart';
import 'boards/create_reply_screen.dart';
import 'firebase_options.dart';
import 'galleries/gallery_view_screen.dart';
import 'gfffts/gffft_api.dart';
import 'gfffts/gffft_feature.screen.dart';
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
    // FirebaseCrashlytics doesn't work on web
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    if (kDebugMode && false) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
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

// First way to monitor changes in the routing stack:
class NavigationObserver extends VxObserver {
  @override
  void didChangeRoute(Uri route, Page page, String pushOrPop) {
    print("${route.path} - $pushOrPop");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print("pushed ${route} - $previousRoute");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print("popped ${route} - $previousRoute");
  }
}

class _AppState extends State<App> {
  final navigator = VxNavigator(
      observers: [NavigationObserver()],
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
        "/": (uri, params) {
          if (FirebaseAuth.instance.currentUser != null) {
            return MaterialPage(child: HomeScreen());
          }
          return MaterialPage(child: LoginScreen());
        },
        BookmarkScreen.webPath: (uri, params) {
          if (FirebaseAuth.instance.currentUser != null) {
            return const MaterialPage(child: BookmarkScreen());
          }
          return MaterialPage(child: LoginScreen());
        },
        HomeScreen.webPath: (uri, params) {
          if (FirebaseAuth.instance.currentUser != null) {
            return MaterialPage(child: HomeScreen());
          }
          return MaterialPage(child: LoginScreen());
        },
        GffftListScreen.webPath: (uri, params) => const MaterialPage(child: GffftListScreen()),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+$"): (uri, param) =>
            MaterialPage(child: GffftHomeScreen(uid: uri.pathSegments[1], gid: uri.pathSegments[3])),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/features$"): (uri, param) =>
            MaterialPage(child: GffftFeatureScreen(uid: uri.pathSegments[1], gid: uri.pathSegments[3])),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/boards/[a-zA-Z0-9]+$"): (uri, param) => MaterialPage(
                child: BoardViewScreen(
              uid: uri.pathSegments[1],
              gid: uri.pathSegments[3],
              bid: uri.pathSegments[5],
            )),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/boards/[a-zA-Z0-9]+/post$"): (uri, param) => MaterialPage(
                child: CreatePostScreen(
              uid: uri.pathSegments[1],
              gid: uri.pathSegments[3],
              bid: uri.pathSegments[5],
            )),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/boards/[a-zA-Z0-9]+/threads/[a-zA-Z0-9]+$"):
            (uri, param) => MaterialPage(
                    child: ThreadViewScreen(
                  uid: uri.pathSegments[1],
                  gid: uri.pathSegments[3],
                  bid: uri.pathSegments[5],
                  tid: uri.pathSegments[7],
                )),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/boards/[a-zA-Z0-9]+/threads/[a-zA-Z0-9]+/reply$"):
            (uri, param) => MaterialPage(
                    child: CreateReplyScreen(
                  uid: uri.pathSegments[1],
                  gid: uri.pathSegments[3],
                  bid: uri.pathSegments[5],
                  tid: uri.pathSegments[7],
                )),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/galleries/[a-zA-Z0-9]+$"): (uri, param) => MaterialPage(
                child: GalleryViewScreen(
              uid: uri.pathSegments[1],
              gid: uri.pathSegments[3],
              mid: uri.pathSegments[5],
            )),
        RegExp(r"users\/[a-zA-Z0-9\.\-]+/gfffts/[a-zA-Z0-9]+/galleries/[a-zA-Z0-9]+/post$"): (uri, param) =>
            MaterialPage(
                child: GalleryPostScreen(
              uid: uri.pathSegments[1],
              gid: uri.pathSegments[3],
              mid: uri.pathSegments[5],
            )),
        GffftScreen.webPath: (uri, params) => MaterialPage(child: GffftScreen()),
        LoginScreen.webPath: (uri, params) => MaterialPage(child: LoginScreen()),
        MeScreen.webPath: (uri, params) => MaterialPage(child: MeScreen()),
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

  Widget authenticationGate(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;

        if (user == null) {
          // id like to remove thi eentire StreamBuilder, but for some reason
          // when I do the page doesn't render at all

          // navigation can't happen here because the router isn't set up yet.
          // instead this auth check is taking place in home_screen.dart

          //navigator.push(Uri(path: LoginScreen.webPath));
          // VxNavigator.of(context).push(Uri(path: LoginScreen.webPath));
        } else {
          print("user is not null");
        }

        // final User? user = snapshot.data;
        // var initialRoute = snapshot.hasData && user != null ? HomeScreen.webPath : LoginScreen.webPath;

        return MaterialApp.router(
          title: 'gffft',
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
  }

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
      errorColor: const Color(0xFFB87171),
      scaffoldBackgroundColor: const Color(0xFF33333D),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.blue),
      outlinedButtonTheme: _getOutlineButtonThemeData(context),
      textButtonTheme: _getTextButtonThemeData(context),
      backgroundColor: const Color(0xFF33333D),
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
          bodyText1: GoogleFonts.sourceSansPro(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.normal,
              letterSpacing: letterSpacingOrNone(0.5),
              color: Colors.white),
          bodyText2: GoogleFonts.sourceSansPro(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
            color: Colors.lightGreen,
          ),
          button: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacingOrNone(2.8),
            color: Colors.lightBlue[200],
          ),
          headline1: GoogleFonts.sourceSansPro(color: Color(0xFF1C839E), fontSize: 40, fontWeight: FontWeight.w100),
          headline4: GoogleFonts.sourceSansPro(color: Colors.lightGreenAccent),
          headline5: GoogleFonts.sourceSansPro(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
          subtitle1: TextStyle(color: Colors.lightGreenAccent), // input text
          headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        );
  }
}
