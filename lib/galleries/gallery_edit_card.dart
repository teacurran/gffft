import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class GalleryEditCard extends StatelessWidget {
  const GalleryEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);
    GffftApi gffftApi = getIt<GffftApi>();

    bool galleryEnabled = false;
    String galleryWhoCanView = "owner";
    String galleryWhoCanPost = "owner";

    if (gffft.hasFeature("gallery") && gffft.galleries != null && gffft.galleries!.isNotEmpty) {
      galleryEnabled = true;
      galleryWhoCanView = gffft.galleries!.first.whoCanView;
      galleryWhoCanPost = gffft.galleries!.first.whoCanPost;
    }

    if (galleryWhoCanPost == "owner") {
      galleryWhoCanPost = "just you";
    }
    if (galleryWhoCanView == "owner") {
      galleryWhoCanView = "just you";
    }

    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color(0xFF00829C),
            width: 1.0,
          )),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.photoVideo),
                color: const Color(0xFF00829C),
                onPressed: () {},
              ),
              Text(
                l10n!.gffftHomeGallery,
                style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF00829C)),
              )
            ]),
            Row(
              children: [
                Flexible(
                    child: Text(
                  l10n.gffftSettingsGalleryEnableHint,
                  style: theme.textTheme.bodyText1,
                  softWrap: true,
                ))
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsGalleryEnable,
                  style: theme.textTheme.bodyText1,
                ),
                Switch(
                  value: galleryEnabled,
                  onChanged: (value) {
                    GffftPatchSave gffft = GffftPatchSave(
                      uid: this.gffft.uid,
                      gid: this.gffft.gid,
                      galleryEnabled: value,
                    );

                    gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                  },
                )
              ],
            ),
            // Row(
            //   children: [
            //     Text(
            //       l10n.gffftSettingsBoardWhoCanView,
            //       style: theme.textTheme.bodyText1,
            //     ),
            //     Padding(
            //         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            //         child: DropdownButton<String>(
            //           value: galleryWhoCanView,
            //           items: <String>['just you', 'admins', 'moderators', 'members', 'public'].map((String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value),
            //             );
            //           }).toList(),
            //           onChanged: (_) {},
            //         )),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Text(
            //       l10n.gffftSettingsBoardWhoCanPost,
            //       style: theme.textTheme.bodyText1,
            //     ),
            //     Padding(
            //         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            //         child: DropdownButton<String>(
            //           value: galleryWhoCanPost,
            //           items: <String>['just you', 'admins', 'moderators', 'members', 'public'].map((String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value),
            //             );
            //           }).toList(),
            //           onChanged: (_) {},
            //         )),
            //   ],
            // )
          ])),
    );
  }
}
