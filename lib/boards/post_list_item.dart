import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gffft/common/dates.dart';

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
    final theme = Theme.of(context);
    return Card(
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Column(children: [
              Row(
                children: [
                  Text(
                    post.author.handle,
                    style: theme.textTheme.bodyText1,
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
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(children: [
                    Expanded(
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
