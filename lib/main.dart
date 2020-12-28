import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gffft/screens/app_screen.dart';
import 'package:gffft/screens/auth_screen.dart';
import 'package:gffft/src/auth_model.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';


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
          // Using MultiProvider is convenient when providing multiple objects.
          return MultiProvider(
            providers: [
              // In this sample app, CatalogModel never changes, so a simple Provider
              // is sufficient.
              Provider(create: (context) => AuthModel()),
              // CartModel is implemented as a ChangeNotifier, which calls for the use
              // of ChangeNotifierProvider. Moreover, CartModel depends
              // on CatalogModel, so a ProxyProvider is needed.
              ChangeNotifierProxyProvider<AuthModel, CartModel>(
                create: (context) => CartModel(),
                update: (context, auth, cart) {
                  return cart;
                },
              ),
            ],
            child: MaterialApp(
              title: 'Provider Demo',
              initialRoute: '/',
              routes: {
                '/': (context) => AuthScreen(),
                '/catalog': (context) => AppScreen(),
                '/cart': (context) => AppScreen(),
              },
            ),
          );
        });
  }
}