import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class GffftSearchCard extends StatelessWidget {
  GffftSearchCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;
  GffftApi gffftApi = getIt<GffftApi>();

  bool boardEnabled = false;
  String boardWhoCanView = "owner";
  String boardWhoCanPost = "owner";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);

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

    return SizedBox(
        height: 300,
        width: 300,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFFFABB59)),
                    color: const Color(0xFFFABB59),
                    onPressed: () {},
                  ),
                  Text(
                    l10n!.gffftSettingsHead,
                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                  )
                ]),
                Row(
                  children: [
                    Text(
                      l10n.gffftSettingsEnabled,
                      style: theme.textTheme.bodyText1,
                    ),
                    Switch(
                      value: gffft.enabled,
                      onChanged: (value) {
                        GffftPatchSave gffft = GffftPatchSave(
                          uid: this.gffft.uid,
                          gid: this.gffft.gid,
                          enabled: value,
                        );

                        gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      l10n.gffftSettingsEnabledHint,
                      style: theme.textTheme.bodyText1,
                      softWrap: true,
                    ))
                  ],
                ),
                Row(
                  children: [
                    Text(
                      l10n.gffftSettingsEnableMembership,
                      style: theme.textTheme.bodyText1,
                    ),
                    Switch(
                      value: gffft.allowMembers,
                      onChanged: (value) {
                        GffftPatchSave gffft = GffftPatchSave(
                          uid: this.gffft.uid,
                          gid: this.gffft.gid,
                          allowMembers: value,
                        );

                        gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      l10n.gffftSettingsEnableMembershipHint,
                      style: theme.textTheme.bodyText1,
                      softWrap: true,
                    ))
                  ],
                )
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
