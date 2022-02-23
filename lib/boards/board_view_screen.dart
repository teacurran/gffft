import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/thread_title.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/thread.dart';

final getIt = GetIt.instance;

class BoardViewScreen extends StatefulWidget {
  const BoardViewScreen({Key? key, required this.uid, required this.gid, required this.bid}) : super(key: key);

  final String uid;
  final String gid;
  final String bid;

  @override
  _BoardViewScreenState createState() => _BoardViewScreenState();
}

class _BoardViewScreenState extends State<BoardViewScreen> {
  UserApi userApi = getIt<UserApi>();
  static const _pageSize = 200;
  final PagingController<String?, Thread> _pagingController = PagingController(firstPageKey: null);
  Future<Gffft>? gffft;

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
      final newItems = await userApi.getBoardThreads(
        widget.uid,
        widget.gid,
        widget.bid,
        pageKey,
        _pageSize,
      );

      final isLastPage = newItems.count < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        _pagingController.appendPage(newItems.items, newItems.items.last.id);
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

  Widget? getFloatingActionButton(BuildContext context, Gffft? gffft) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (gffft == null) {
      return null;
    }
    if (gffft.me == null) {
      return null;
    }
    return FloatingActionButton(
        child: Icon(Icons.add, color: theme.focusColor),
        tooltip: l10n!.boardViewActionTooltip,
        backgroundColor: theme.primaryColor,
        onPressed: () {
          VxNavigator.of(context)
              .waitAndPush(Uri(
                  path: "/" +
                      Uri(pathSegments: ["users", gffft.uid, "gfffts", gffft.gid, "boards", widget.bid, "post"])
                          .toString()))
              .then((value) {
            _pagingController.refresh();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          var gffft = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  l10n!.gffftHomeBoard,
                  style: theme.textTheme.headline1,
                ),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: theme.secondaryHeaderColor),
                    onPressed: () => _pagingController.refresh(),
                  )
                ],
              ),
              floatingActionButton: getFloatingActionButton(context, gffft),
              body: CustomScrollView(slivers: <Widget>[
                PagedSliverList<String?, Thread>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Thread>(
                      animateTransitions: true,
                      itemBuilder: (context, item, index) {
                        return ThreadTitle(
                            uid: widget.uid, gid: widget.gid, bid: widget.bid, pager: _pagingController, thread: item);
                      },
                    ))
              ]));
        });
  }
}
