import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/style/app_theme.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.host,
          style: theme.textTheme.headline1,
        ),
        backgroundColor: theme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.primaryColorLight),
            onPressed: () => Navigator.pop(context),
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text(l10n.host),
      ),
    );
  }
}
