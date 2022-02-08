import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

import '../users/user_api.dart';
import 'models/gallery_item.dart';

final getIt = GetIt.instance;

class ItemViewScreen extends StatefulWidget {
  const ItemViewScreen({
    Key? key,
    required this.uid,
    required this.gid,
    required this.mid,
    required this.iid,
  }) : super(key: key);

  final String uid;
  final String gid;
  final String mid;
  final String iid;

  @override
  State<ItemViewScreen> createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  UserApi userApi = getIt<UserApi>();

  Future<GalleryItem>? item;
  final String storageHost = dotenv.get("STORAGE_HOST", fallback: "127.0.0.1");

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    setState(() {
      item = userApi.getGalleryItem(widget.uid, widget.gid, widget.mid, widget.iid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              VxNavigator.of(context).pop();
              // VxNavigator.of(context).replace(Uri(
              //     path: "/" +
              //         Uri(pathSegments: [
              //           "users",
              //           widget.uid,
              //           "gfffts",
              //           widget.gid,
              //           "galleries",
              //           widget.mid,
              //         ]).toString()));
            },
            child: FutureBuilder<GalleryItem>(
              future: item,
              builder: (_, snapshot) {
                Widget content = Container();
                var galleryItem = snapshot.data;
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
                  }
                }
                return Hero(
                  tag: widget.iid,
                  child: content,
                );
              },
            )));
  }
}
