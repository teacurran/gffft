import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class BoardEditCard extends StatelessWidget {
  BoardEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;
  final GffftApi gffftApi = getIt<GffftApi>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);

    bool boardEnabled = false;
    String boardWhoCanView = "owner";
    String boardWhoCanPost = "owner";

    if (gffft.hasFeature("board") && gffft.boards != null && gffft.boards!.isNotEmpty) {
      boardEnabled = true;
      boardWhoCanView = gffft.boards!.first.whoCanView;
      boardWhoCanPost = gffft.boards!.first.whoCanPost;
    }

    // hack until drop downs are internationalized
    if (boardWhoCanPost == "owner") {
      boardWhoCanPost = "just you";
    }
    if (boardWhoCanView == "owner") {
      boardWhoCanView = "just you";
    }

    return Card(
      margin: const EdgeInsets.all(8),
      color: theme.backgroundColor,
      child: Container(
          padding: EdgeInsets.all(10),
          height: 300,
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.commentAlt),
                color: const Color(0xFF9970A9),
                onPressed: () {},
              ),
              Text(
                l10n!.gffftHomeBoard,
                style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
              )
            ]),
            Row(
              children: [
                Flexible(
                    child: Text(
                  l10n.gffftSettingsEnableMessageBoardHint,
                  style: theme.textTheme.bodyText1,
                  softWrap: true,
                ))
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsEnableMessageBoard,
                  style: theme.textTheme.bodyText1,
                ),
                Switch(
                  value: boardEnabled,
                  onChanged: (value) {
                    GffftPatchSave gffft = GffftPatchSave(
                      uid: this.gffft.uid,
                      gid: this.gffft.gid,
                      boardEnabled: value,
                    );

                    gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                  },
                )
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsBoardWhoCanView,
                  style: theme.textTheme.bodyText1,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: boardWhoCanView,
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
                  l10n.gffftSettingsBoardWhoCanPost,
                  style: theme.textTheme.bodyText1,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: boardWhoCanPost,
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color(0xFF9970A9),
            width: 1.0,
          )),
    );
  }
}
