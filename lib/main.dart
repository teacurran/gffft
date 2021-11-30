import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gffft/screens/app_screen.dart';
import 'package:gffft/screens/auth_screen.dart';
import 'package:gffft/src/auth_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return loadingScreen(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return defaultState(context);
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
      home: const Scaffold(
      ),
    );
  }

  Widget defaultState(BuildContext context) {
    var authModel = AuthModel();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
          create: (context) => authModel
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        title: 'Provider Demo',
        initialRoute: authModel.getCurrentUser() == null ? '/' : '/home',
        routes: {
          '/': (context) => Scaffold(body: AuthScreen()),
          '/home': (context) => const Scaffold(body: AppScreen()),
          '/catalog': (context) => const Scaffold(body: AppScreen()),
          '/cart': (context) => const Scaffold(body: AppScreen()),
        },
        theme: ThemeData(
          highlightColor: Colors.deepPurple,
          primaryColor: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }

}
