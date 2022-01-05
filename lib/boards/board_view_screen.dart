import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';

import 'create_post_screen.dart';

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

    Future _handlePost(String subject, String body) async {
      print("handlePost: $subject, $body");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gffft.name),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: theme.focusColor),
            tooltip: l10n!.boardViewActionTooltip,
            backgroundColor: theme.primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(
                      gffft: widget.gffft,
                      onSaved: _handlePost,
                    ),
                  ));
            }),
        body: const Padding(padding: EdgeInsets.all(16.0), child: CustomScrollView()));
  }
}
