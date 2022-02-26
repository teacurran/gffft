import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class CalendarEditCard extends StatelessWidget {
  const CalendarEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

    GffftApi gffftApi = getIt<GffftApi>();

    String calendarWhoCanView = "owner";
    String calendarWhoCanPost = "owner";

    if (gffft.hasFeature("calendar") && gffft.calendars != null && gffft.calendars!.isNotEmpty) {
      calendarWhoCanView = gffft.calendars!.first.whoCanView;
      calendarWhoCanPost = gffft.calendars!.first.whoCanPost;
    }

    // hack until drop downs are internationalized
    if (calendarWhoCanPost == "owner") {
      calendarWhoCanPost = "just you";
    }
    if (calendarWhoCanView == "owner") {
      calendarWhoCanView = "just you";
    }

    return Card(
      margin: const EdgeInsets.all(8),
      color: theme.backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color(0xFFB56277),
            width: 1.0,
          )),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.calendarAlt),
              color: const Color(0xFFB56277),
              onPressed: () {},
            ),
            Text(
              l10n!.gffftHomeCalendar,
              style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFB56277)),
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  l10n.gffftSettingsEnableCalendarHint,
                  style: theme.textTheme.bodyText1,
                  softWrap: true,
                ))
              ],
            ),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsEnableCalendar,
                  style: theme.textTheme.bodyText1,
                ),
                Switch(
                  value: gffft.hasFeature('calendar'),
                  onChanged: (value) {
                    GffftPatchSave gffft = GffftPatchSave(
                      uid: this.gffft.uid,
                      gid: this.gffft.gid,
                      calendarEnabled: value,
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
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: calendarWhoCanView,
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
                      value: calendarWhoCanPost,
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
