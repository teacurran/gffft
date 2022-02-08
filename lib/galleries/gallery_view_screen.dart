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
                              thumb = ExtendedImage.network(thumbUrl, height: 320, width: 320, cache: true,
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

                                    thumb = Hero(
                                        tag: item.id,
                                        child:
                                            ExtendedRawImage(image: state.extendedImageInfo?.image, fit: BoxFit.cover));

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
                              });
                            } else {
                              thumb = CommonCircularProgressIndicator();
                            }

                            return Hero(
                                tag: item.id,
                                child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: InkWell(
                                        onTap: () {
                                          if (gffft != null) {
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

                                            Navigator.of(context).push(MaterialPageRoute<void>(
                                                fullscreenDialog: true,
                                                maintainState: true,
                                                builder: (BuildContext context) {
                                                  return Scaffold(
                                                      body: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Container(
                                                              // The blue background emphasizes that it's a new route.
                                                              color: Colors.black54,
                                                              alignment: Alignment.topLeft,
                                                              child: (fullImageUrl != null)
                                                                  ? Hero(
                                                                      tag: item.id,
                                                                      child: ExtendedImage.network(fullImageUrl,
                                                                          width: double.infinity,
                                                                          height: double.infinity,
                                                                          fit: BoxFit.contain,
                                                                          alignment: Alignment.center,
                                                                          mode: ExtendedImageMode.gesture,
                                                                          initGestureConfigHandler: (state) {
                                                                        return GestureConfig(
                                                                          minScale: 0.9,
                                                                          animationMinScale: 0.7,
                                                                          maxScale: 3.0,
                                                                          animationMaxScale: 3.5,
                                                                          speed: 1.0,
                                                                          inertialSpeed: 100.0,
                                                                          initialScale: 1.0,
                                                                          inPageView: false,
                                                                          initialAlignment: InitialAlignment.center,
                                                                        );
                                                                      }))
                                                                  : Container())));
                                                }));
                                          }
                                        },
                                        child: thumb!)));
                          },
                        ))
                  ])));
        });
  }
}
