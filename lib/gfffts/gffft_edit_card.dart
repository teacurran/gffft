import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class GffftEditCard extends StatefulWidget {
  GffftEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;

  @override
  State<GffftEditCard> createState() => _GffftEditCardState();
}

class _GffftEditCardState extends State<GffftEditCard> {
  GffftApi gffftApi = getIt<GffftApi>();

  late TextEditingController _titleController;
  late TextEditingController _introController;
  late TextEditingController _descController;

  bool boardEnabled = false;
  String boardWhoCanView = "owner";
  String boardWhoCanPost = "owner";

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.gffft.name);
    _introController = TextEditingController(text: widget.gffft.intro);
    _descController = TextEditingController(text: widget.gffft.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    _descController.dispose();

    super.dispose();
  }

  Future<void> _saveIntroText() async {
    GffftPatchSave gffft = GffftPatchSave(
      uid: widget.gffft.uid,
      gid: widget.gffft.gid,
      intro: _introController.text,
    );

    gffftApi.savePartial(gffft).then((value) => widget.onSaveComplete);
  }

  Future<void> _saveDescription() async {
    GffftPatchSave gffft = GffftPatchSave(
      uid: widget.gffft.uid,
      gid: widget.gffft.gid,
      description: _descController.text,
    );

    gffftApi.savePartial(gffft).then((value) => widget.onSaveComplete);
  }

  Future<void> _saveTitle() async {
    GffftPatchSave gffft = GffftPatchSave(
      uid: widget.gffft.uid,
      gid: widget.gffft.gid,
      name: _titleController.text,
    );

    gffftApi.savePartial(gffft).then((value) => widget.onSaveComplete);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

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
                    child: Focus(
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "name"),
                        ),
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            _saveTitle();
                          }
                        })),
                Padding(
                    padding: fieldPadding,
                    child: Focus(
                        child: TextField(
                          decoration: const InputDecoration(labelText: "description (optional)"),
                          controller: _descController,
                          textInputAction: TextInputAction.go,
                          maxLines: 2,
                        ),
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            _saveDescription();
                          }
                        })),
                Padding(
                    padding: fieldPadding,
                    child: Focus(
                        child: TextField(
                          decoration: const InputDecoration(labelText: "intro (optional)"),
                          controller: _introController,
                          textInputAction: TextInputAction.go,
                          maxLines: 5,
                        ),
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            _saveIntroText();
                          }
                        })),
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
