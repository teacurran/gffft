import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../users/user_api.dart';

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
  static const _pageSize = 200;
  final PagingController<String?, GalleryItem> _pagingController = PagingController(firstPageKey: null);
  Future<Gffft>? gffft;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File>(
        future: imageFile,
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          return Image.file(file);
        },
      ),
    );
  }
}
