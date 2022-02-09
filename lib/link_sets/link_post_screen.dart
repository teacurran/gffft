import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'link_set_api.dart';
import 'models/link_submit.dart';

final getIt = GetIt.instance;

class LinkPostScreen extends StatefulWidget {
  const LinkPostScreen({Key? key, required this.uid, required this.gid, required this.lid}) : super(key: key);

  final String uid;
  final String gid;
  final String lid;

  @override
  State<LinkPostScreen> createState() => _LinkPostScreenState();
}

class _LinkPostScreenState extends State<LinkPostScreen> {
  UserApi userApi = getIt<UserApi>();
  LinkSetApi linkSetApi = getIt<LinkSetApi>();

  bool isLoading = false;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Future<Gffft>? gffft;

  void postLink() async {
    setState(() {
      isLoading = true;
    });

    LinkSubmit linkSubmit =
        LinkSubmit(widget.uid, widget.gid, widget.lid, _urlController.text, description: _descriptionController.text);

    await linkSetApi.createLink(linkSubmit);

    VxNavigator.of(context).returnAndPush(true);
  }

  Future<void> _loadGffft() async {
    setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid);
    });
  }

  @override
  void initState() {
    _loadGffft();

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ImagePicker imagePicker = ImagePicker();

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
              automaticallyImplyLeading: false,
              title: Text(title, style: theme.textTheme.headline1),
              backgroundColor: theme.backgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                onPressed: () => VxNavigator.of(context).returnAndPush(true),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(hintText: l10n!.galleryPostCaption),
                  maxLines: 1,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: l10n.galleryPostCaption),
                  maxLines: 1,
                ),
                TextButton(
                  onPressed: () => postLink(),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                )
              ],
            ),
          );
        });
  }
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
