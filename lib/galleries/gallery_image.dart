import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../components/common_circular_progress_indicator.dart';
import 'models/gallery_item.dart';

///
///  crop_image.dart
///  create by zmtzawqlp on 2019/4/4
///

class GalleryImage extends StatelessWidget {
  const GalleryImage({
    required this.item,
    required this.size,
    required this.knowImageSize,
  });

  final GalleryItem item;
  final bool knowImageSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!item.thumbnail) {
      return Container();
    }
    String? imageUrl = item.urls[size.toString()];
    if (imageUrl == null) {
      return Container();
    }

    double height = size;
    double width = size;

    return ExtendedImage.network(imageUrl,
        width: width,
        clearMemoryCacheWhenDispose: false,
        imageCacheName: 'CropImage',
        height: height, loadStateChanged: (ExtendedImageState state) {
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
          state.returnLoadStateChangedWidget = !knowImageSize;

          widget =
              Hero(tag: item.id, child: ExtendedRawImage(image: state.extendedImageInfo?.image, fit: BoxFit.cover));

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

      return widget;
    });
  }
}
