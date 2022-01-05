import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';

class BoardViewScreen extends StatefulWidget {
  const BoardViewScreen({Key? key, required this.gffft}) : super(key: key);

  final GffftMinimal gffft;

  @override
  _BoardViewScreen createState() => _BoardViewScreen();
}

class _BoardViewScreen extends State<BoardViewScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gffft.name),
          backgroundColor: theme.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add, color: theme.focusColor),
          tooltip: l10n!.boardViewActionTooltip,
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(padding: const EdgeInsets.all(16.0), child: CustomScrollView()));
  }
}
