import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:velocity_x/velocity_x.dart';

import '../gfffts/models/gffft.dart';

final getIt = GetIt.instance;

class GalleryHomeCard extends StatelessWidget {
  const GalleryHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: theme.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Color(0xFF00829C),
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              VxNavigator.of(context).push(Uri(
                  path: "/" +
                      Uri(pathSegments: ["users", gffft.uid, "gfffts", gffft.gid, "galleries", featureRef.id!])
                          .toString()));
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
                          icon: const FaIcon(
                            FontAwesomeIcons.photoVideo,
                            color: Color(0xFF00829C),
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          l10n!.gffftHomeGallery,
                          style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF00829C)),
                        )
                      ]),
                      const VerticalDivider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: const [SelectableText("photos:"), SelectableText("2938")]),
                            Row(children: const [SelectableText("videos:"), SelectableText("14")]),
                          ])
                    ])))));
  }
}
