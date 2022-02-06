import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import 'item_view_screen.dart';
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
  static const _pageSize = 200;
  final PagingController<String?, GalleryItem> _pagingController = PagingController(firstPageKey: null);
  Future<Gffft>? gffft;

  final String storageHost = dotenv.get("STORAGE_HOST", fallback: "127.0.0.1");

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
      final newItems = await userApi.getGallery(
        widget.uid,
        widget.gid,
        widget.mid,
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: theme.secondaryHeaderColor),
                    onPressed: () => _pagingController.refresh(),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: theme.focusColor),
                  tooltip: l10n!.boardViewActionTooltip,
                  backgroundColor: theme.primaryColor,
                  onPressed: () {
                    VxNavigator.of(context)
                        .waitAndPush(Uri(
                            pathSegments: ["users", widget.uid, "gfffts", widget.gid, "galleries", widget.mid, "post"]))
                        .then((value) {
                      _pagingController.refresh();
                    });
                  }),
              body: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: CustomScrollView(slivers: <Widget>[
                    PagedSliverGrid(
                        pagingController: _pagingController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                        builderDelegate: PagedChildBuilderDelegate<GalleryItem>(
                          animateTransitions: true,
                          itemBuilder: (context, item, index) {
                            var thumbUrl = item.urls["320"];
                            thumbUrl = thumbUrl?.replaceAll("127.0.0.1", storageHost);

                            var fullImageUrl = item.urls["1024"];
                            fullImageUrl = fullImageUrl?.replaceAll("127.0.0.1", storageHost);
                            if (thumbUrl != null && gffft != null) {
                              return InkWell(
                                  onTap: () {
                                    VxNavigator.of(context)
                                        .waitAndPush(Uri(pathSegments: [
                                          "users",
                                          gffft.uid,
                                          "gfffts",
                                          gffft.gid,
                                          "galleries",
                                          widget.mid,
                                          "i",
                                          item.id
                                        ]))
                                        .then((value) => _pagingController.refresh());
                                  },
                                  child: Image.network(thumbUrl));
                            } else {
                              return SvgPicture.asset('assets/spinner_320.svg');
                            }
                          },
                        ))
                  ])));
        });
  }
}
