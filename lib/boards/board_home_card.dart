import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/models/gffft.dart';
import 'board_view_screen.dart';
import 'models/board.dart';

final getIt = GetIt.instance;

class BoardHomeCard extends StatelessWidget {
  const BoardHomeCard({Key? key, required this.gffft, required this.featureRef}) : super(key: key);

  final Gffft gffft;
  final GffftFeatureRef featureRef;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

    Board? board;
    if (gffft.boards != null) {
      for (var b in gffft.boards!) {
        if (b.id == featureRef.id) {
          board = b;
        }
      }
    }

    final newThreads = gffft.membership?.updateCounters?.boardThreads ?? 0;
    final newPosts = gffft.membership?.updateCounters?.galleryVideos ?? 0;

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Color(0xFF9970A9),
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BoardViewScreen(uid: gffft.uid, gid: gffft.gid, bid: featureRef.id!);
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
                          icon: const FaIcon(FontAwesomeIcons.commentAlt),
                          color: const Color(0xFF9970A9),
                          onPressed: () {},
                        ),
                        Text(
                          l10n!.gffftHomeBoard,
                          style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
                        )
                      ]),
                      const VerticalDivider(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(children: [
                              SelectableText(l10n.gffftHomeBoardThreads),
                              SelectableText(
                                  (board == null) ? "?" : board.threads.toString() + ((newThreads > 0) ? ", " : "")),
                              if (newThreads > 0)
                                SelectableText(l10n.gffftHomeBoardThreadsNew(newThreads),
                                    style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)),
                            ]),
                            Row(children: [
                              SelectableText(l10n.gffftHomeBoardPosts),
                              SelectableText(
                                  (board == null) ? "?" : board.posts.toString() + ((newPosts > 0) ? ", " : "")),
                            ]),
                            if (newPosts > 0)
                              SelectableText(l10n.gffftHomeBoardPostsNew(newPosts),
                                  style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)),
                          ])
                    ])))));
  }
}
