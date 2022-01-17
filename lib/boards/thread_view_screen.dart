import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/models/thread_post_result.dart';
import 'package:gffft/boards/post_list_item.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/post.dart';

final getIt = GetIt.instance;

class ThreadViewScreen extends StatefulWidget {
  const ThreadViewScreen({Key? key, required this.uid, required this.gid, required this.bid, required this.tid})
      : super(key: key);

  final String uid;
  final String gid;
  final String bid;
  final String tid;

  @override
  _ThreadViewScreenState createState() => _ThreadViewScreenState();
}

class _ThreadViewScreenState extends State<ThreadViewScreen> {
  UserApi userApi = getIt<UserApi>();
  static const _pageSize = 200;
  final PagingController<String?, Post> _pagingController = PagingController(firstPageKey: null);
  Future<Gffft>? gffft;
  ThreadPostResult? thread;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    _loadGffft();

    super.initState();
  }

  Future<void> _loadGffft() async {
    setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid);
    });
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final thread = await userApi.getThread(
        widget.uid,
        widget.gid,
        widget.bid,
        widget.tid,
        pageKey,
        _pageSize,
      );

      setState(() {
        this.thread = thread;
      });

      print("got threads!${thread.posts.length}");
      final isLastPage = thread.posts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(thread.posts);
      } else {
        _pagingController.appendPage(thread.posts, thread.posts.last.id);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          var title = "connecting";
          if (snapshot.hasError) {
            title = "error";
          }

          var gffft = snapshot.data;
          if (gffft != null) {
            title = gffft.name ?? "";
          }

          var threadTitle = "";
          if (thread != null) {
            threadTitle = thread!.subject;
          }

          // thread?.subject != null ? Text(thread!.subject) : Container()

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  title,
                  style: theme.textTheme.headline1,
                ),
                backgroundColor: theme.backgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
                  onPressed: () => VxNavigator.of(context).pop(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: theme.focusColor),
                  tooltip: l10n!.boardViewActionTooltip,
                  backgroundColor: theme.primaryColor,
                  onPressed: () {
                    VxNavigator.of(context)
                        .waitAndPush(Uri(pathSegments: [
                      "users",
                      widget.uid,
                      "gfffts",
                      widget.gid,
                      "boards",
                      widget.bid,
                      "threads",
                      widget.tid,
                      "reply"
                    ]))
                        .then((value) {
                      _pagingController.refresh();
                    });
                  }),
              body: CustomScrollView(slivers: <Widget>[
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                  child: Text(
                    threadTitle,
                    style: theme.textTheme.headline6?.copyWith(fontSize: 30),
                  ),
                )),
                PagedSliverList<String?, Post>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                      animateTransitions: true,
                      itemBuilder: (context, item, index) => PostListItem(
                            uid: widget.uid,
                            gid: widget.gid,
                            bid: widget.bid,
                            tid: widget.tid,
                            post: item,
                          )),
                )
              ]));
        });
  }
}
