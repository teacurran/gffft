import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'link_preview_card.dart';
import 'models/link_set_item.dart';

final getIt = GetIt.instance;

class LinkSetViewScreen extends StatefulWidget {
  const LinkSetViewScreen({Key? key, required this.uid, required this.gid, required this.lid}) : super(key: key);

  final String uid;
  final String gid;
  final String lid;

  @override
  _LinkSetViewScreenState createState() => _LinkSetViewScreenState();
}

class _LinkSetViewScreenState extends State<LinkSetViewScreen> {
  UserApi userApi = getIt<UserApi>();
  static const _pageSize = 200;
  final PagingController<String?, LinkSetItem> _pagingController = PagingController(firstPageKey: null);
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
      final newItems = await userApi.getLinkSet(
        widget.uid,
        widget.gid,
        widget.lid,
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
        tooltip: l10n!.linkSetViewActionTooltip,
        backgroundColor: theme.primaryColor,
        onPressed: () {
          VxNavigator.of(context)
              .waitAndPush(Uri(
                  path: "/" +
                      Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "links", widget.lid, "post"])
                          .toString()))
              .then((value) {
            _pagingController.refresh();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
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

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "links",
                  style: theme.textTheme.headline1,
                ),
                backgroundColor: theme.backgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
                  onPressed: () => VxNavigator.of(context).pop(),
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
                PagedSliverList<String?, LinkSetItem>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<LinkSetItem>(
                      animateTransitions: true,
                      itemBuilder: (context, item, index) {
                        return Padding(padding: EdgeInsets.fromLTRB(15, 0, 10, 10), child: LinkPreviewCard(link: item));
                      },
                    ))
              ]));
        });
  }
}
