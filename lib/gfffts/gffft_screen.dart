import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/gfffts/gffft_edit_screen.dart';
import 'package:gffft/style/app_theme.dart';

class GffftScreen extends StatelessWidget {
  static const String webPath = '/me';

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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GffftEditScreen(),
                  ));
            },
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
