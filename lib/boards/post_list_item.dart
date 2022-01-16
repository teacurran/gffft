import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/thread.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.uid, required this.gid, required this.bid, required this.thread})
      : super(key: key);

  final String uid;
  final String gid;
  final String bid;
  final Thread thread;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (context) {},
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.save,
              label: 'Save',
            ),
          ],
        ),
        child: InkWell(
            onTap: () {
              VxNavigator.of(context)
                  .push(Uri(pathSegments: ["users", uid, "gfffts", gid, "boards", bid, "threads", thread.id]));
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        thread.firstPost.handle,
                        style: theme.textTheme.bodyText1,
                      ),
                      Expanded(
                          child: Text(
                        thread.postCount.toString(),
                        style: theme.textTheme.bodyText1,
                        textAlign: TextAlign.right,
                      ))
                    ],
                  ),
                  Row(children: [
                    Expanded(
                        child: Text(
                      thread.subject,
                      style: theme.textTheme.headline6,
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ))
                  ])
                ],
              ),
            )));
  }
}