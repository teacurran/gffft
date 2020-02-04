import 'package:flutter/material.dart';
import 'package:gffft/screens/auth_screen.dart';
import 'package:gffft/src/auth_bloc_provider.dart';

void main() {
  runApp(new GffftApp());
}

class GffftApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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