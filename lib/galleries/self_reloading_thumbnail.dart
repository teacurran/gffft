import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/users/user_api.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/common_circular_progress_indicator.dart';
import '../style/letter_spacing.dart';
import 'models/gallery_item.dart';

final getIt = GetIt.instance;

class SelfReloadingThumbnail extends StatefulWidget {
  const SelfReloadingThumbnail(
      {Key? key,
      required this.uid,
      required this.gid,
      required this.mid,
      required this.iid,
      required this.size,
      this.initialGalleryItem,
      this.listView = false})
      : super(key: key);

  final String uid;
  final String gid;
  final String mid;
  final String iid;
  final GalleryItem? initialGalleryItem;
  final double size;
  final bool listView;

  @override
  State<SelfReloadingThumbnail> createState() => _SelfReloadingThumbnailState();
}

class _SelfReloadingThumbnailState extends State<SelfReloadingThumbnail> {
  UserApi userApi = getIt<UserApi>();

  Future<GalleryItem>? galleryItem;
  final String storageHost = dotenv.get("STORAGE_HOST", fallback: "127.0.0.1");
  Timer? reloadTimer = null;

  @override
  void initState() {
    _initialLoadIfNeccessary();
    super.initState();
  }

  void _likeItem(GalleryItem item) {
    if (kDebugMode) {
      print("double tap received: ${item.id}");
    }
  }

  Future<void> _initialLoadIfNeccessary() async {
    if (kDebugMode) {
      print("_initialLoadIfNeccessary()");
    }
    if (widget.initialGalleryItem != null) {
      if (widget.initialGalleryItem?.thumbnail ?? false) {
        var completer = Completer<GalleryItem>();
        completer.complete(widget.initialGalleryItem);
        setState(() {
          galleryItem = completer.future;
        });
      }
    }

    if (galleryItem == null) {
      var gi = await userApi.getGalleryItem(widget.uid, widget.gid, widget.mid, widget.iid);
      if (gi.thumbnail) {
        var completer = Completer<GalleryItem>();
        completer.complete(gi);
        setState(() {
          galleryItem = completer.future;
        });
      } else {
        reloadTimer = Timer(const Duration(seconds: 1), () {
          _initialLoadIfNeccessary();
        });
      }
    }

    setState(() {
      galleryItem = galleryItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: galleryItem,
        builder: (context, AsyncSnapshot<GalleryItem?> snapshot) {
          var title = "connecting";
          if (snapshot.hasError) {
            title = "error";
          }

          var item = snapshot.data;
          if (item == null) {
            return CommonCircularProgressIndicator();
          }

          var imageUrl = item.urls[widget.size.toInt().toString()];
          imageUrl = imageUrl?.replaceAll("127.0.0.1", storageHost);

          Widget? thumb;
          if (imageUrl != null) {
            thumb = ExtendedImage.network(imageUrl, cache: true, loadStateChanged: (ExtendedImageState state) {
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
                      tag: item.id, child: ExtendedRawImage(image: state.extendedImageInfo?.image, fit: BoxFit.cover));

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
          }

          thumb ??= CommonCircularProgressIndicator();

          if (!widget.listView) {
            return thumb!;
          }

          return Column(children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: SelectableText(item.author.handle ?? 'unknown',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    letterSpacing: letterSpacingOrNone(2.8),
                    color: Colors.lightBlue,
                  )),
            ),
            GestureDetector(onDoubleTap: () => _likeItem(item), child: thumb)
          ]);
        });
  }
}
