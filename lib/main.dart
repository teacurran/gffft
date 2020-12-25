import 'package:flutter/material.dart';
import 'package:gffft/screens/auth_screen.dart';
import 'package:gffft/src/auth_bloc_provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
          accentColor: Colors.teal,
          primaryColor: Colors.blue,
        ),
        home: Scaffold(
        ),
      );
  }

  Widget defaultState(BuildContext context) {
    return AuthBlocProvider(
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Colors.teal,
          primaryColor: Colors.blue,
        ),
        home: Scaffold(
          body: AuthScreen(),
        ),
      ),
    );
  }
}