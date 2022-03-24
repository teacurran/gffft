import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/models/gffft.dart';

final getIt = GetIt.instance;

class GffftEditCard extends StatelessWidget {
  GffftEditCard(
      {Key? key,
      required this.gffft,
      this.onSaveComplete,
      required this.titleController,
      required this.introController,
      required this.descController})
      : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;
  final TextEditingController titleController;
  final TextEditingController introController;
  final TextEditingController descController;
  var isSaving = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.gffftSettingsHead,
          style: theme.textTheme.headline1,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.backgroundColor,
      body:
          PageView(physics: const PageScrollPhysics(), controller: PageController(viewportFraction: 0.8), children: []),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: getFloatingActionButton(context, gffft),
    );
  }

  Widget? getFloatingActionButton(BuildContext context, Gffft? gffft) {
    if (isSaving) {
      return FloatingActionButton(
          child: const CircularProgressIndicator(), backgroundColor: const Color(0xFFFABB59), onPressed: () {});
    }
    return FloatingActionButton.extended(
        icon: const Icon(Icons.arrow_right_alt, color: Colors.black),
        label: Text("next"),
        backgroundColor: const Color(0xFFFABB59),
        onPressed: () {});
  }

  Widget getEditPage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    const fieldPadding = EdgeInsets.fromLTRB(0, 5, 0, 20);
    return SingleChildScrollView(
      child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(children: [
                  const Padding(padding: fieldPadding, child: Icon(Icons.settings, color: Color(0xFFFABB59))),
                  Text(
                    l10n!.gffftSettingsGeneralHead,
                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                  )
                ]),
                Padding(
                    padding: fieldPadding,
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.gffftEditCardName),
                    )),
                Padding(
                    padding: fieldPadding,
                    child: TextField(
                      decoration: InputDecoration(labelText: l10n.gffftEditCardDescription),
                      controller: descController,
                      textInputAction: TextInputAction.newline,
                      maxLines: 2,
                    )),
                Padding(
                    padding: fieldPadding,
                    child: TextField(
                      decoration: InputDecoration(labelText: l10n.gffftEditCardIntro),
                      controller: introController,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                    )),
              ])),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: Color(0xFFFABB59),
                width: 1.0,
              ))),
    );
  }
}
