import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class NotebookEditCard extends StatelessWidget {
  const NotebookEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);
    GffftApi gffftApi = getIt<GffftApi>();

    bool notebookEnabled = false;
    String notebookWhoCanView = "owner";
    String notebookWhoCanPost = "owner";

    if (gffft.hasFeature("notebook") && gffft.notebooks != null && gffft.notebooks!.isNotEmpty) {
      notebookEnabled = true;
      notebookWhoCanView = gffft.notebooks!.first.whoCanView;
      notebookWhoCanPost = gffft.notebooks!.first.whoCanPost;
    }

    if (notebookWhoCanPost == "owner") {
      notebookWhoCanPost = "just you";
    }
    if (notebookWhoCanView == "owner") {
      notebookWhoCanView = "just you";
    }

    return Card(
      margin: const EdgeInsets.all(8),
      color: theme.backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.deepOrangeAccent,
            width: 1.0,
          )),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.fileAlt),
              color: Colors.deepOrangeAccent,
              onPressed: () {},
            ),
            Text(
              l10n!.gffftHomePages,
              style: theme.textTheme.headline6?.copyWith(color: Colors.deepOrangeAccent),
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  l10n.gffftSettingsNotebookEnableHint,
                  style: theme.textTheme.bodyText1,
                  softWrap: true,
                ))
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsNotebookEnable,
                  style: theme.textTheme.bodyText1,
                ),
                Switch(
                  value: notebookEnabled,
                  onChanged: (value) {
                    GffftPatchSave gffft = GffftPatchSave(
                      uid: this.gffft.uid,
                      gid: this.gffft.gid,
                      notebookEnabled: value,
                    );

                    gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsNotebookWhoCanView,
                  style: theme.textTheme.bodyText1,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: notebookWhoCanView,
                      items: <String>['just you', 'admins', 'moderators', 'members', 'public'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    )),
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsNotebookWhoCanEdit,
                  style: theme.textTheme.bodyText1,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: notebookWhoCanPost,
                      items: <String>['just you', 'admins', 'moderators', 'members', 'public'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    )),
              ],
            )
          ])),
    );
  }
}
