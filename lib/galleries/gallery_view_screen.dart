import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/galleries/gallery_post_screen.dart';
import 'package:gffft/galleries/paged_item_view_screen.dart';
import 'package:gffft/galleries/self_reloading_thumbnail.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'models/gallery_item.dart';

final getIt = GetIt.instance;

class GalleryViewScreen extends StatefulWidget {
  const GalleryViewScreen({Key? key, required this.uid, required this.gid, required this.mid}) : super(key: key);

  final String uid;
  final String gid;
  final String mid;

  @override
  State<GalleryViewScreen> createState() => _GalleryViewScreenState();
}

class _GalleryViewScreenState extends State<GalleryViewScreen> {
  UserApi userApi = getIt<UserApi>();
  final PagingController<String?, GalleryItem> _pagingController = PagingController(firstPageKey: null);
  Future<Gffft>? gffft;
  bool showGridView = false;

  final String storageHost = dotenv.get("STORAGE_HOST", fallback: "127.0.0.1");

  List<GalleryItem> itemList = List<GalleryItem>.empty(growable: true);

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

  void _toggleView() {
    setState(() {
      showGridView = !showGridView;
    });
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final pageSize = showGridView ? 20 : 4;
      final newItems = await userApi.getGallery(
        widget.uid,
        widget.gid,
        widget.mid,
        pageKey,
        pageSize,
      );

      final isLastPage = newItems.count < pageSize;
      itemList.addAll(newItems.items);
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.items);
      } else {
        _pagingController.appendPage(newItems.items, newItems.items.last.id);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  GalleryItem? getItemInfo(int index) {
    if (itemList.length == 1) {
      return itemList.first;
    }
    if (index > itemList.length - 1) {
      index = index.remainder(itemList.length - 1) - 1;
    }
    var range = itemList.sublist(index, index + 1);
    if (range.isEmpty) {
      return null;
    }
    return range.first;
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  Widget? getFloatingActionButton(BuildContext context, Gffft? gffft) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    if (gffft == null) {
      return null;
    }
    if (gffft.membership == null || gffft.membership?.type == "anon") {
      return null;
    }
    return FloatingActionButton(
        child: Icon(Icons.add, color: theme.focusColor),
        tooltip: l10n!.boardViewActionTooltip,
        backgroundColor: theme.primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GalleryPostScreen(uid: widget.uid, gid: widget.gid, mid: widget.mid);
          })).then((value) {
            itemList = List<GalleryItem>.empty(growable: true);
            _pagingController.refresh();
          });
        });
  }

  Widget _getGridView(BuildContext context) {
    return PagedSliverGrid(
        pagingController: _pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
        builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
          animateTransitions: true,
          itemBuilder: (context, item, index) {
            Widget thumb = SelfReloadingThumbnail(
              size: 320,
              uid: widget.uid,
              gid: widget.gid,
              mid: widget.mid,
              iid: item.id,
              initialGalleryItem: item,
            );

            var fullImageUrl = item.urls["1024"];
            fullImageUrl = fullImageUrl?.replaceAll("127.0.0.1", storageHost);

            return Hero(
                tag: item.id,
                child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: GestureDetector(
                        onTap: () {
                          if (fullImageUrl != null) {
                            // VxNavigator.of(context).push(Uri(
                            //     path: "/" +
                            //         Uri(pathSegments: [
                            //           "users",
                            //           gffft.uid,
                            //           "gfffts",
                            //           gffft.gid,
                            //           "galleries",
                            //           widget.mid,
                            //           "i",
                            //           item.id
                            //         ]).toString()));

                            Navigator.of(context).push(PageRouteBuilder(
                                fullscreenDialog: true,
                                maintainState: true,
                                pageBuilder: (BuildContext context, Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return Scaffold(
                                      body: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          onPanUpdate: (details) {
                                            // Swiping in down direction.
                                            if (details.delta.dy > 0) {
                                              Navigator.of(context).pop();
                                            }

                                            // Swiping in up direction.
                                            if (details.delta.dy < 0) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: PagedItemViewScreen(
                                              uid: widget.uid,
                                              gid: widget.gid,
                                              mid: widget.mid,
                                              index: index,
                                              getItemInfo: getItemInfo)));
                                }));
                          }
                        },
                        child: thumb)));
          },
        ));
  }

  void _onItemDeleted(String iid) {
    if (kDebugMode) {
      print("item has been deleted:$iid");
    }
  }

  Widget _getListView(BuildContext context) {
    final ThemeData theme = context.appTheme.materialTheme;
    return PagedSliverList(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
          animateTransitions: true,
          itemBuilder: (context, item, index) {
            return SelfReloadingThumbnail(
                size: 1024,
                uid: widget.uid,
                gid: widget.gid,
                mid: widget.mid,
                iid: item.id,
                initialGalleryItem: item,
                listView: true,
                onItemDeleted: _onItemDeleted);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final ThemeData theme = context.appTheme.materialTheme;

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

          final toggleViewIcon = (showGridView) ? Icons.photo : Icons.view_comfortable;

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  l10n!.gffftHomeGallery,
                  style: theme.textTheme.headline1,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(toggleViewIcon, color: theme.secondaryHeaderColor),
                    onPressed: () => _toggleView(),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: theme.secondaryHeaderColor),
                    onPressed: () => _pagingController.refresh(),
                  )
                ],
              ),
              floatingActionButton: getFloatingActionButton(context, gffft),
              body: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: RefreshIndicator(
                      onRefresh: () async {
                        _pagingController.refresh();
                      },
                      child: CustomScrollView(
                          slivers: <Widget>[if (showGridView) _getGridView(context) else _getListView(context)]))));
        });
  }
}
