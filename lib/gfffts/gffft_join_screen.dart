import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';

import 'gffft_api.dart';
import 'models/gffft.dart';

final getIt = GetIt.instance;

class GffftJoinScreen extends StatefulWidget {
  const GffftJoinScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

  @override
  State<GffftJoinScreen> createState() => _GffftJoinScreenState();
}

class _GffftJoinScreenState extends State<GffftJoinScreen> {
  final defaultId = "{default}";

  late TextEditingController _handleController;

  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<Gffft>? gffft;

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.setCurrentScreen(screenName: "gffft_join");
    _loadGffft();
  }

  Future<void> _loadGffft() async {
    return setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid).then((gffft) {
        // initialize this to a default handle for the user?
        _handleController = TextEditingController();
        return gffft;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          String gffftName = "loading";
          if (snapshot.hasError) {
            gffftName = "error";
          }

          var shareText = "${l10n!.gffftSettingsFruitCodeShare}\n";

          var gffft = snapshot.data;
          if (gffft != null) {
            gffftName = "${gffft.name}";
            if (gffftName == defaultId) {
              gffftName = "My gffft";
            }

            shareText = shareText + "${gffft.fruitCode[0]}${gffft.fruitCode[1]}${gffft.fruitCode[2]}\n";
            shareText = shareText + "${gffft.fruitCode[3]}${gffft.fruitCode[4]}${gffft.fruitCode[5]}\n";
            shareText = shareText + "${gffft.fruitCode[6]}${gffft.fruitCode[7]}${gffft.fruitCode[8]}\n";
          }

          Widget content = (gffft == null) ? Container() : getJoinContent(l10n, theme);

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: SelectableText(
                  l10n.gffftJoin,
                  style: theme.textTheme.headline1,
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                  child: Column(children: [
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
                                color: Colors.transparent,
                                child: content,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Color(0xFFFABB59),
                                      width: 1.0,
                                    )),
                              )),
                        ]))
              ])),
            ),
          );
        });
  }

  Widget getJoinContent(AppLocalizations l10n, ThemeData theme) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
              Row(
                children: [
                  SelectableText(
                    l10n.gffftJoinRules,
                    style: theme.textTheme.headline3,
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: SelectableText(
                    "here will be some rules for this gffft.\n  *maybe bullet points\n  *like, no jerks\n  *let users configure this?",
                    style: theme.textTheme.bodyText1,
                  ))
                ],
              ),
              Row(
                children: [
                  SelectableText(
                    l10n.gffftJoinHandle,
                    style: theme.textTheme.headline3,
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: SelectableText(
                    l10n.gffftJoinHandleHint,
                    style: theme.textTheme.bodyText1,
                  ))
                ],
              ),
              Row(
                children: [
                  Flexible(
                      child: TextFormField(
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                    controller: _handleController,
                    maxLength: 128,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ))
                ],
              ),
              OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      await gffftApi.joinGffft(widget.uid, widget.gid, _handleController.text);
                      // todo: check for errors here (username taken, etc)

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(l10n.gffftJoinButton)),
            ])));
  }

  @override
  void dispose() {
    _handleController.dispose();
    super.dispose();
  }
}
