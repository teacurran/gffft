import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gffft/common/dates.dart';

import '../link_sets/link_preview_card.dart';
import 'models/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem(
      {Key? key, required this.uid, required this.gid, required this.bid, required this.tid, required this.post})
      : super(key: key);

  final String uid;
  final String gid;
  final String bid;
  final String tid;
  final Post post;

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(children: [
              Row(
                children: [
                  Slidable(
                    startActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Text(l10n!.boardThreadAuthorVisit),
                      ],
                    ),
                    child: Text(
                      post.author.handle ?? post.author.id,
                      style: theme.textTheme.bodyText1,
                    ),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Expanded(
                            child: Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      l10n.boardThreadAuthorReport,
                                      style: theme.textTheme.bodyText1?.copyWith(
                                          color: theme.errorColor,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: Colors.white),
                                      textAlign: TextAlign.right,
                                    )))),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Text(
                    formatDateTime(post.createdAt),
                    style: theme.textTheme.bodyText1,
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(children: [
                    if (post.link != null) LinkPreviewCard(url: post.link?.url ?? '', link: post.link),
                    SizedBox(
                        width: double.infinity,
                        child: Text(
                          post.body,
                          style: theme.textTheme.headline6,
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ))
                  ])),
            ])));
  }
}
