import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:velocity_x/velocity_x.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';

final getIt = GetIt.instance;

class NotebookHomeCard extends StatelessWidget {
  const NotebookHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

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
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: theme.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.deepOrangeAccent,
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              VxNavigator.of(context).push(Uri(
                  path: "/" +
                      Uri(pathSegments: ["users", gffft.uid, "gfffts", gffft.gid, "boards", featureRef.id!])
                          .toString()));
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                child: SizedBox(
                    width: double.infinity,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                        IconButton(
                            icon: const FaIcon(FontAwesomeIcons.fileAlt),
                            color: Colors.deepOrangeAccent,
                            onPressed: () async {}),
                        Text(
                          l10n!.gffftHomePages,
                          style: theme.textTheme.headline6?.copyWith(color: Colors.deepOrangeAccent),
                        )
                      ]),
                      const VerticalDivider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: const [SelectableText("pages:"), SelectableText("38")]),
                            Row(children: const [SelectableText("edits:"), SelectableText("297")]),
                          ])
                    ])))));
  }
}
