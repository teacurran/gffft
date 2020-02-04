import 'package:flutter/material.dart';
import 'package:gffft/src/auth_bloc.dart';

class AuthBlocProvider extends InheritedWidget {
  final bloc = AuthBloc();

  AuthBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AuthBloc of(BuildContext context) {
    // todo: should be using this new method, figure out why not. might need some other way to search for AuthBlocProvider
    // final newValue = context.dependOnInheritedWidgetOfExactType();

    return (context.inheritFromWidgetOfExactType(AuthBlocProvider)
    as AuthBlocProvider)
        .bloc;

  }
}