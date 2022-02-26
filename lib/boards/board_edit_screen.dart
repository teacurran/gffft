import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/style/app_theme.dart';

class BoardEditScreen extends StatelessWidget {
  const BoardEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n!.host),
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(l10n.host),
      ),
    );
  }
}
