import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

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
    final theme = Theme.of(context);
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

    return SizedBox(
        height: 300,
        width: 300,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: theme.backgroundColor,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xFFFABB59)),
                  color: const Color(0xFFFABB59),
                  onPressed: () {},
                ),
                Text(
                  l10n!.gffftSettingsGeneralHead,
                  style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                ),
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
                              style: theme.textTheme.headline1,
                              textAlign: TextAlign.center,
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
                              maxLines: 5,
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
              )),
        ));
  }
}
