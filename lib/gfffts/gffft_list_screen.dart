import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GffftListScreen extends StatefulWidget {
  const GffftListScreen({Key? key}) : super(key: key);

  static const String id = 'Gffft List';

  @override
  _GffftListScreen createState() => _GffftListScreen();
}

class _GffftListScreen extends State<GffftListScreen> {
  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n!.connect),
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("l10n.connect"),
      ),
    );
  }
}
