import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

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
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<GalleryItem>(
        future: item,
        builder: (_, snapshot) {
          var galleryItem = snapshot.data;
          if (galleryItem != null) {
            var fullImageUrl = galleryItem.urls["1024"];
            fullImageUrl = fullImageUrl?.replaceAll("127.0.0.1", storageHost);
            if (fullImageUrl != null) {
              return Image.network(fullImageUrl);
            }
          }
          return Container();
        },
      ),
    );
  }
}
