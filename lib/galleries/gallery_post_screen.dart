import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';
import 'package:image_picker/image_picker.dart';

import 'gallery_api.dart';

final getIt = GetIt.instance;

class GalleryPostScreen extends StatefulWidget {
  const GalleryPostScreen({Key? key, required this.uid, required this.gid, required this.mid}) : super(key: key);

  final String uid;
  final String gid;
  final String mid;

  @override
  State<GalleryPostScreen> createState() => _GalleryPostScreenState();
}

class _GalleryPostScreenState extends State<GalleryPostScreen> {
  UserApi userApi = getIt<UserApi>();
  GalleryApi galleryApi = getIt<GalleryApi>();

  XFile? _file;
  Uint8List? _fileBytes;
  bool isLoading = false;
  double _progressValue = 0;

  final TextEditingController _descriptionController = TextEditingController();
  Future<Gffft>? gffft;

  void postImage() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await galleryApi.uploadGalleryItem(widget.uid, widget.gid, widget.mid, _descriptionController.text, _file!);

    Navigator.pop(context);
  }

  // void _setUploadProgress(int sentBytes, int totalBytes) {
  //   double __progressValue = remap(sentBytes.toDouble(), 0, totalBytes.toDouble(), 0, 1);
  //
  //   __progressValue = double.parse(__progressValue.toStringAsFixed(2));
  //
  //   if (__progressValue != _progressValue) {
  //     setState(() {
  //       _progressValue = __progressValue;
  //     });
  //   }
  // }

  static double remap(double value, double originalMinValue, double originalMaxValue, double translatedMinValue,
      double translatedMaxValue) {
    if (originalMaxValue - originalMinValue == 0) return 0;

    return (value - originalMinValue) /
            (originalMaxValue - originalMinValue) *
            (translatedMaxValue - translatedMinValue) +
        translatedMinValue;
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
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
    final theme = context.appTheme.materialTheme;
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
                title: Text(l10n!.galleryPostTitle, style: theme.textTheme.headline1),
                backgroundColor: theme.backgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
              ),
              body: _file == null
                  ? Column(
                      children: [
                        Center(
                            child: TextButton.icon(
                          onPressed: () async {
                            XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                            if (file != null) {
                              final fileBytes = await file.readAsBytes();
                              setState(() {
                                _file = file;
                                _fileBytes = fileBytes;
                              });
                            }
                          },
                          icon: const Icon(Icons.photo_camera),
                          label: const Text("take a photo"),
                          style: theme.outlinedButtonTheme.style,
                        )),
                        Center(
                            child: TextButton.icon(
                                onPressed: () async {
                                  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                  if (file != null) {
                                    final fileBytes = await file.readAsBytes();
                                    setState(() {
                                      _file = file;
                                      _fileBytes = fileBytes;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.upload),
                                label: const Text("upload a photo")))
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                        const Divider(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_fileBytes!),
                            )),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(hintText: l10n.galleryPostCaption),
                              maxLines: 1,
                            ),
                            TextButton(
                              onPressed: () => postImage(),
                              child: const Text(
                                "Post",
                                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    ));
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
