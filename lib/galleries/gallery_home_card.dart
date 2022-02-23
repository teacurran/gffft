import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/galleries/gallery_view_screen.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';

import '../gfffts/models/gffft.dart';
import 'models/gallery.dart';

final getIt = GetIt.instance;

class GalleryHomeCard extends StatelessWidget {
  const GalleryHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);

    Gallery? gallery;
    if (gffft.galleries != null) {
      for (var g in gffft.galleries!) {
        if (g.id == featureRef.id) {
          gallery = g;
        }
      }
    }

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Color(0xFF00829C),
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GalleryViewScreen(uid: gffft.uid, gid: gffft.gid, mid: featureRef.id!);
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
                            Row(children: [
                              SelectableText(l10n.gffftHomeGalleryPhotos),
                              SelectableText((gallery == null) ? "?" : gallery.photoCount.toString())
                            ]),
                            Row(children: [
                              SelectableText(l10n.gffftHomeGalleryVideos),
                              SelectableText((gallery == null) ? "?" : gallery.videoCount.toString())
                            ]),
                          ])
                    ])))));
  }
}
