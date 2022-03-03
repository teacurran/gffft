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

  bool boardEnabled = false;
  String boardWhoCanView = "owner";
  String boardWhoCanPost = "owner";

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.gffft.name);
    _introController = TextEditingController(text: widget.gffft.intro);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

    Future<void> _saveIntroText() async {
      GffftPatchSave gffft = GffftPatchSave(
        uid: widget.gffft.uid,
        gid: widget.gffft.gid,
        intro: _introController.text,
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

    return SingleChildScrollView(
      child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFFFABB59)),
                    color: const Color(0xFFFABB59),
                    onPressed: () {},
                  ),
                  Text(
                    l10n!.gffftSettingsGeneralHead,
                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                  )
                ]),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      "name",
                      style: theme.textTheme.bodyText1,
                      softWrap: true,
                    ))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Focus(
                            child: TextField(
                              style: theme.textTheme.headline1?.copyWith(fontSize: 18),
                              textAlign: TextAlign.left,
                              controller: _titleController,
                              textInputAction: TextInputAction.go,
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                _saveTitle();
                              }
                            }))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      "intro (optional)",
                      style: theme.textTheme.bodyText1,
                      softWrap: true,
                    ))
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Focus(
                            child: TextField(
                              style: theme.textTheme.bodyText1?.copyWith(fontSize: 20),
                              controller: _introController,
                              textInputAction: TextInputAction.go,
                              maxLines: 3,
                            ),
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                _saveIntroText();
                              }
                            }))
                  ],
                ),
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
