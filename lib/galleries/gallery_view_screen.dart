import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:velocity_x/velocity_x.dart';

import '../components/common_circular_progress_indicator.dart';
import 'gallery_image.dart';
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
                            path: "/" +
                                Uri(pathSegments: [
                                  "users",
                                  widget.uid,
                                  "gfffts",
                                  widget.gid,
                                  "galleries",
                                  widget.mid,
                                  "post"
                                ]).toString()))
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

                            Widget? thumb;
                            if (thumbUrl != null && gffft != null && fullImageUrl != null) {
                              thumb = InkWell(
                                  onTap: () {
                                    VxNavigator.of(context)
                                        .waitAndPush(Uri(
                                            path: "/" +
                                                Uri(pathSegments: [
                                                  "users",
                                                  gffft.uid,
                                                  "gfffts",
                                                  gffft.gid,
                                                  "galleries",
                                                  widget.mid,
                                                  "i",
                                                  item.id
                                                ]).toString()))
                                        .then((value) => _pagingController.refresh());
                                  },
                                  child: ExtendedImage.network(thumbUrl, height: 320, width: 320,
                                      loadStateChanged: (ExtendedImageState state) {
                                    Widget? widget;
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.loading:
                                        widget = CommonCircularProgressIndicator();
                                        break;
                                      case LoadState.completed:

                                        //if you can't konw image size before build,
                                        //you have to handle crop when image is loaded.
                                        //so maybe your loading widget size will not the same
                                        //as image actual size, set returnLoadStateChangedWidget=true,so that
                                        //image will not to be limited by size which you set for ExtendedImage first time.
                                        state.returnLoadStateChangedWidget = false;

                                        ///if you don't want override completed widget
                                        ///please return null or state.completedWidget
                                        //return null;

                                        widget = Hero(
                                          tag: item.id,
                                          child: GalleryImage(knowImageSize: true, size: 320, item: item),
                                        );

                                        break;
                                      case LoadState.failed:
                                        widget = GestureDetector(
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/failed.jpg',
                                                fit: BoxFit.fill,
                                              ),
                                              const Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Text(
                                                  'load image failed, click to reload',
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            state.reLoadImage();
                                          },
                                        );
                                        break;
                                    }
                                  }));
                            } else {
                              thumb = CommonCircularProgressIndicator();
                            }

                            return Padding(
                              padding: EdgeInsets.all(1),
                              child: thumb,
                            );
                          },
                        ))
                  ])));
        });
  }
}
