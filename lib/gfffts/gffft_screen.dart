import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/gfffts/gffft_edit_screen.dart';

class GffftScreen extends StatelessWidget {
  static const String id = 'Gffft';

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
            onPressed: () => Navigator.pushNamed(context, GffftEditScreen.id),
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
