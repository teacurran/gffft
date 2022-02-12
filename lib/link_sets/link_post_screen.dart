import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
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
  String? url;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Future<Gffft>? gffft;
  final _formKey = GlobalKey<FormState>();

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
            body: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                SizedBox(
                  height: 375,
                  child: PageView(
                      physics: const PageScrollPhysics(),
                      controller: PageController(viewportFraction: 0.95),
                      children: [
                        SizedBox(
                            height: 300,
                            width: 300,
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              color: theme.backgroundColor,
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                        if (url != null && url!.isNotEmpty)
                                          AnyLinkPreview(
                                            link: url!,
                                            displayDirection: UIDirection.UIDirectionHorizontal,
                                            showMultimedia: true,
                                            bodyMaxLines: 5,
                                            bodyTextOverflow: TextOverflow.ellipsis,
                                            titleStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            bodyStyle: const TextStyle(color: Colors.black12, fontSize: 12),
                                            errorBody: 'Show my custom error body',
                                            errorTitle: 'Show my custom error title',
                                            errorWidget: Container(
                                              color: Colors.grey[300],
                                              child: const Text('Oops!'),
                                            ),
                                            errorImage: "https://google.com/",
                                            cache: const Duration(days: 7),
                                            backgroundColor: Colors.grey[300],
                                            borderRadius: 8,
                                            removeElevation: false,
                                            boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
                                            onTap: () {}, // This disables tap event
                                          ),
                                        Focus(
                                          child: TextField(
                                            controller: _urlController,
                                            decoration: InputDecoration(hintText: l10n!.linkSetPostUrl),
                                            maxLines: 1,
                                            onChanged: (value) {
                                              setState(() {
                                                url = value;
                                              });
                                            },
                                          ),
                                          onFocusChange: (hasFocus) async {
                                            if (!hasFocus) {
                                              var linkInfo = await linkSetApi.getLink(_urlController.text);
                                              if (kDebugMode) {
                                                print("linkInfo: ${linkInfo.toString()}");
                                              }
                                            }
                                          },
                                        ),
                                        TextField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(hintText: l10n.linkSetPostDescription),
                                          maxLines: 1,
                                        ),
                                        TextButton(
                                            onPressed: () => postLink(),
                                            child: const Text(
                                              "Post",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ))
                                      ]))),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                    color: Color(0xFFFABB59),
                                    width: 1.0,
                                  )),
                            )),
                      ]),
                )
              ],
            )),
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
