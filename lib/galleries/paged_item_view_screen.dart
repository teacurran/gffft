import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../users/user_api.dart';
import 'models/gallery_item.dart';

final getIt = GetIt.instance;

class PagedItemViewScreen extends StatefulWidget {
  const PagedItemViewScreen({
    Key? key,
    required this.uid,
    required this.gid,
    required this.mid,
    required this.index,
    required this.getItemInfo,
  }) : super(key: key);

  final String uid;
  final String gid;
  final String mid;
  final int index;
  final GalleryItem? Function(int) getItemInfo;

  @override
  State<PagedItemViewScreen> createState() => _PagedItemViewScreenState();
}

class _PagedItemViewScreenState extends State<PagedItemViewScreen> {
  UserApi userApi = getIt<UserApi>();

  final String storageHost = dotenv.get("STORAGE_HOST", fallback: "127.0.0.1");
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.index, keepPage: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        Widget content = Container();
        var galleryItem = widget.getItemInfo(index);

        if (galleryItem != null) {
          var fullImageUrl = galleryItem.urls["1024"];
          fullImageUrl = fullImageUrl?.replaceAll("127.0.0.1", storageHost);

          if (fullImageUrl != null) {
            content = ExtendedImage.network(
              fullImageUrl,
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
              },
            );
          } else {
            return Text("no full image?");
          }
          return Hero(
            tag: galleryItem.id,
            child: content,
          );
        } else {
          return Text("no gallery item?");
        }
      },
    ));
  }
}
