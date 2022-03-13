import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:gffft/link_sets/link_set_view_screen.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/models/gffft.dart';
import 'models/link_set.dart';

final getIt = GetIt.instance;

class LinkSetHomeCard extends StatelessWidget {
  const LinkSetHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

  static const kCardColor = Color(0xFFEFFF8D);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final ThemeData theme = context.appTheme.materialTheme;

    LinkSet? linkSet;
    if (gffft.linkSets != null) {
      for (var b in gffft.linkSets!) {
        if (b.id == featureRef.id) {
          linkSet = b;
        }
      }
    }
    final newLinks = gffft.membership?.updateCounters?.linkSetItems ?? 0;

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: kCardColor,
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LinkSetViewScreen(uid: gffft.uid, gid: gffft.gid, lid: featureRef.id!);
              }));
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                child: SizedBox(
                    width: double.infinity,
                    child: Row(children: [
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.link),
                          color: kCardColor,
                          onPressed: () {},
                        ),
                        Text(
                          l10n!.gffftHomeLinkSet,
                          style: theme.textTheme.headline6?.copyWith(color: kCardColor),
                        )
                      ]),
                      const VerticalDivider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: [
                              SelectableText(l10n.gffftHomeLinkSetLinks),
                              SelectableText((linkSet == null)
                                  ? "0"
                                  : linkSet.itemCount.toString() + ((newLinks > 0) ? ", " : "")),
                              if (newLinks > 0)
                                SelectableText(l10n.gffftHomeLinkSetLinksNew(newLinks),
                                    style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)),
                            ]),
                          ])
                    ])))));
  }
}
