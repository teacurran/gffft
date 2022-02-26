import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/models/gffft.dart';

final getIt = GetIt.instance;

class CalendarHomeCard extends StatelessWidget {
  const CalendarHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: theme.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Color(0xFFB56277),
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {},
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                child: SizedBox(
                    width: double.infinity,
                    child: Row(children: [
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        IconButton(
                            icon: const FaIcon(FontAwesomeIcons.calendarAlt),
                            onPressed: () {},
                            color: const Color(0xFFB56277)),
                        Text(
                          l10n!.gffftHomeCalendar,
                          style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFB56277)),
                        )
                      ]),
                      const VerticalDivider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: const [SelectableText("future events:"), SelectableText("45")]),
                            Row(children: const [SelectableText("past events:"), SelectableText("32")]),
                          ])
                    ])))));
  }
}
