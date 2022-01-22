import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gffft_api.dart';
import 'models/gffft.dart';
import 'models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class GffftFeatureScreen extends StatefulWidget {
  const GffftFeatureScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

  @override
  State<GffftFeatureScreen> createState() => _GffftFeatureScreenState();
}

class _GffftFeatureScreenState extends State<GffftFeatureScreen> {
  final defaultId = "{default}";

  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  Future<Gffft>? gffft;

  @override
  void initState() {
    super.initState();
    _loadGffft();
  }

  Future<void> _loadGffft() async {
    return setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid).then((gffft) {
        return gffft;
      });
    });
  }

  Widget? getFloatingActionButton(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return FloatingActionButton.extended(
        icon: const Icon(Icons.save, color: Colors.black),
        label: Text(l10n!.gffftSettingsSave),
        backgroundColor: const Color(0xFFFABB59),
        tooltip: l10n.gffftSettingsSave,
        onPressed: () {
          VxNavigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          Widget screenBody = Column();

          var title = "connecting";
          if (snapshot.hasError) {
            title = "error";
          }

          String name = "loading";
          var gffft = snapshot.data;
          if (gffft != null) {
            title = "";

            name = "${gffft.name}";
            if (name == defaultId) {
              name = "${gffft.me.username}'s gffft";
            }
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  title,
                  style: theme.textTheme.headline1,
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                  onPressed: () => VxNavigator.of(context).pop(),
                ),
                centerTitle: true,
              ),
              body: Column(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                    child: SelectableText(
                      name,
                      style: theme.textTheme.headline1,
                    )),
                SizedBox(
                    height: 300,
                    child: PageView(
                        physics: const PageScrollPhysics(),
                        controller: PageController(viewportFraction: 0.8),
                        children: [
                          SizedBox(
                              height: 300,
                              width: 300,
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                color: theme.backgroundColor,
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.settings, color: Color(0xFFFABB59)),
                                        color: const Color(0xFFFABB59),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        l10n!.gffftSettingsHead,
                                        style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            l10n.gffftSettingsEnabled,
                                            style: theme.textTheme.bodyText1,
                                          ),
                                          Switch(
                                            value: gffft?.enabled ?? false,
                                            onChanged: (value) {
                                              GffftPatchSave gffft = GffftPatchSave(
                                                uid: widget.uid,
                                                gid: widget.gid,
                                                enabled: value,
                                              );

                                              gffftApi.savePartial(gffft).then((value) => {
                                                    setState(() {
                                                      _loadGffft();
                                                    })
                                                  });
                                            },
                                          )
                                        ],
                                      )
                                    ])),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Color(0xFFFABB59),
                                      width: 1.0,
                                    )),
                              )),
                          Card(
                            margin: EdgeInsets.all(8),
                            color: theme.backgroundColor,
                            child: Container(
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.commentAlt),
                                    color: const Color(0xFF9970A9),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n!.gffftHomeBoard,
                                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
                                  )
                                ])),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color(0xFF9970A9),
                                  width: 1.0,
                                )),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            color: Colors.blue,
                            child: Text("blue"),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 200,
                            width: 200,
                            color: Colors.green,
                            child: Text("green"),
                          )
                        ]))
              ]),
              // PageView.builder(
              //   itemCount: 10,
              //   controller: PageController(viewportFraction: 0.7),
              //   onPageChanged: (int index) => setState(() => _index = index),
              //   itemBuilder: (_, i) {
              //     return Transform.scale(
              //       scale: i == _index ? 1 : 0.9,
              //       child: Card(
              //         elevation: 6,
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //         child: Center(
              //           child: Text(
              //             "Card ${i + 1}",
              //             style: TextStyle(fontSize: 32),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              floatingActionButton: getFloatingActionButton(context),
            ),
          );
        });
  }
}
