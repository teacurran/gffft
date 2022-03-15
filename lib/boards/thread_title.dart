import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/thread_view_screen.dart';
import 'package:gffft/common/dates.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'board_api.dart';
import 'models/thread.dart';

final getIt = GetIt.instance;

class ThreadTitle extends StatefulWidget {
  const ThreadTitle(
      {Key? key,
      required this.uid,
      required this.gid,
      required this.bid,
      required this.pager,
      required this.thread,
      this.onItemDeleted})
      : super(key: key);

  final String uid;
  final String gid;
  final String bid;
  final Thread thread;
  final PagingController<String?, Thread> pager;
  final VoidCallback? onItemDeleted;

  @override
  State<ThreadTitle> createState() => _ThreadTitleState();
}

class _ThreadTitleState extends State<ThreadTitle> {
  bool deleteConfirm = false;
  bool deleting = false;
  bool deleted = false;
  final boardApi = getIt<BoardApi>();

  @override
  Widget build(BuildContext context) {
    if (deleted) {
      return Container();
    }
    final theme = context.appTheme.materialTheme;
    return Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) async {
                if (deleting) {
                  return;
                }
                if (deleteConfirm) {
                  setState(() {
                    deleting = true;
                  });

                  await boardApi.deleteItem(widget.uid, widget.gid, widget.bid, widget.thread.id ?? "");

                  if (widget.onItemDeleted != null) {
                    widget.onItemDeleted!();
                  }
                  setState(() {
                    deleted = true;
                  });
                  setState(() {
                    deleteConfirm = true;
                  });
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ThreadViewScreen(uid: widget.uid, gid: widget.gid, bid: widget.bid, tid: widget.thread.id);
              })).then((value) {
                widget.pager.refresh();
              });
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.thread.firstPost.handle ?? widget.thread.firstPost.id,
                        style: theme.textTheme.bodyText1,
                      ),
                      Expanded(
                          child: Text(
                        widget.thread.postCount.toString(),
                        style: theme.textTheme.bodyText1,
                        textAlign: TextAlign.right,
                      )),
                      Expanded(
                          child: Text(
                        formatDateTime(widget.thread.updatedAt),
                        style: theme.textTheme.bodyText1,
                        textAlign: TextAlign.right,
                      ))
                    ],
                  ),
                  Row(children: [
                    Expanded(
                        child: Text(
                      widget.thread.subject,
                      style: theme.textTheme.headline6,
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ))
                  ])
                ],
              ),
            ))));
  }
}
