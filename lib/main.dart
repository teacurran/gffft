import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:flutter_firebase_ui/l10n/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Firebase UI',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FFULocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: new MyHomePage(title: 'Firebase UI'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;
  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }
  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new SignInScreen(
        title: 'Firebase UI',
        header: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text("Login"),
          ),
        ),
        providers: [
          ProvidersTypes.google,
          ProvidersTypes.email
        ],
      );
    } else {
      return new HomeScreen(user: _currentUser);
    }
  }
  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);
    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}
class HomeScreen extends StatelessWidget {
  final FirebaseUser user;
  HomeScreen({this.user});
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        title: new Text('Firebase UI'),
        elevation: 4.0,
      ),
      body: new Container(
          padding: const EdgeInsets.all(16.0),
          decoration: new BoxDecoration(color: Colors.amber),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Welcome,"),
                ],
              ),
              new SizedBox(
                height: 8.0,
              ),
              new Text(user.displayName ?? user.email),
              new SizedBox(
                height: 32.0,
              ),
              new RaisedButton(
                  child: new Text("Sign Out"), onPressed: _logout)
            ],
          )));
  void _logout() {
    FirebaseAuth.instance.signOut();
  }
}