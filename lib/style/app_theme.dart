import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme_data.dart';

class AppTheme extends StatelessWidget {
  final Widget child;

  const AppTheme({required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<AppThemeData>.value(value: AppThemeData(), child: child);
  }
}

extension BuildContextExtension on BuildContext {
  AppThemeData get appTheme {
    return watch<AppThemeData>();
  }
}
