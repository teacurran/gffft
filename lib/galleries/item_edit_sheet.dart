import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import 'gallery_api.dart';
import 'models/gallery_item.dart';

final getIt = GetIt.instance;

class ItemEditSheet extends StatefulWidget {
  final String uid;
  final String gid;
  final String mid;
  final GalleryItem? galleryItem;
  final void Function(GalleryItem)? onItemChanged;
  final VoidCallback? onItemDeleted;

  const ItemEditSheet(
      {Key? key,
      required this.uid,
      required this.gid,
      required this.mid,
      this.galleryItem,
      this.onItemChanged,
      this.onItemDeleted})
      : super(key: key);

  @override
  State<ItemEditSheet> createState() => _ItemEditSheetState();
}

class _ItemEditSheetState extends State<ItemEditSheet> {
  bool deleteConfirm = false;
  bool deleting = false;
  final TextEditingController _titleController = TextEditingController();
  final galleryApi = getIt<GalleryApi>();

  @override
  void initState() {
    _titleController.text = widget.galleryItem?.description ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _deleteButtonPressed() async {
    if (deleting || widget.galleryItem == null) {
      return;
    }
    if (deleteConfirm) {
      setState(() {
        deleting = true;
      });

      await galleryApi.deleteItem(widget.uid, widget.gid, widget.mid, widget.galleryItem?.id ?? "");

      if (widget.onItemDeleted != null) {
        widget.onItemDeleted!();
      }

      Navigator.pop(context);
    }
    setState(() {
      deleteConfirm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    var l10n = AppLocalizations.of(context);

    var deleteText = "delete";
    Widget deleteIcon = const FaIcon(FontAwesomeIcons.trashAlt, size: 14.0);
    if (deleting) {
      deleteText = "deleting";
      deleteIcon = const SizedBox(height: 14, width: 14, child: CircularProgressIndicator());
    }
    if (deleteConfirm) {
      deleteText = "are you sure?";
    }

    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                textAlign: TextAlign.left,
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n!.galleryItemDescription),
              )),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _deleteButtonPressed(),
                label: Text(deleteText),
                style: theme.outlinedButtonTheme.style,
                icon: deleteIcon,
              ),
              OutlinedButton(onPressed: () {}, child: Text("save"), style: theme.outlinedButtonTheme.style),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ]));
  }
}
