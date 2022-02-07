import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  const GffftFeatureScreen({Key? key, required this.uid, required this.gid, this.tid, this.fid}) : super(key: key);

  final String uid;
  final String gid;
  final String? tid;
  final String? fid;

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
          VxNavigator.of(context).returnAndPush(true);
        });
  }

  List<Widget> getFruitCode(BuildContext context, Gffft? gffft) {
    final theme = Theme.of(context);
    var widgets = <Widget>[];

    if (gffft != null) {
      gffft.fruitCode.forEach((fruit) {
        widgets.add(Container(
            child: Text(
          fruit,
          style: theme.textTheme.bodyText1!.copyWith(fontSize: 20),
        )));
      });
    }

    return widgets;
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

          bool boardEnabled = false;
          String boardWhoCanView = "owner";
          String boardWhoCanPost = "owner";

          bool calendarEnabled = false;
          String calendarWhoCanView = "owner";
          String calendarWhoCanPost = "owner";

          bool galleryEnabled = false;
          String galleryWhoCanView = "owner";
          String galleryWhoCanPost = "owner";

          bool notebookEnabled = false;
          String notebookWhoCanView = "owner";
          String notebookWhoCanPost = "owner";

          var shareText = "${l10n!.gffftSettingsFruitCodeShare}\n";

          Widget rareFruitMarker = Flexible(child: Container());
          Widget ultraRareFruitMarker = Flexible(child: Container());

          var gffft = snapshot.data;
          if (gffft != null) {
            title = "";

            name = "${gffft.name}";
            if (name == defaultId) {
              name = "My gffft";
            }

            if (gffft.hasFeature("board") && gffft.boards != null && gffft.boards!.isNotEmpty) {
              boardEnabled = true;
              boardWhoCanView = gffft.boards!.first.whoCanView;
              boardWhoCanPost = gffft.boards!.first.whoCanPost;
            }

            if (gffft.hasFeature("calendars") && gffft.calendars != null && gffft.calendars!.isNotEmpty) {
              calendarEnabled = true;
              calendarWhoCanView = gffft.calendars!.first.whoCanView;
              calendarWhoCanPost = gffft.calendars!.first.whoCanPost;
            }

            if (gffft.hasFeature("gallery") && gffft.galleries != null && gffft.galleries!.isNotEmpty) {
              galleryEnabled = true;
              galleryWhoCanView = gffft.galleries!.first.whoCanView;
              galleryWhoCanPost = gffft.galleries!.first.whoCanPost;
            }

            if (gffft.hasFeature("notebook") && gffft.notebooks != null && gffft.notebooks!.isNotEmpty) {
              notebookEnabled = true;
              galleryWhoCanView = gffft.notebooks!.first.whoCanView;
              galleryWhoCanPost = gffft.notebooks!.first.whoCanPost;
            }

            shareText = shareText + "${gffft.fruitCode[0]}${gffft.fruitCode[1]}${gffft.fruitCode[2]}\n";
            shareText = shareText + "${gffft.fruitCode[3]}${gffft.fruitCode[4]}${gffft.fruitCode[5]}\n";
            shareText = shareText + "${gffft.fruitCode[6]}${gffft.fruitCode[7]}${gffft.fruitCode[8]}\n";

            if (gffft.ultraRareFruits > 0) {
              ultraRareFruitMarker = const Flexible(
                  flex: 3,
                  child: Text(
                    "ULTRA\nRARE\nFRUIT",
                    style: TextStyle(fontFamily: 'DoubleFeature', color: Colors.yellow, fontSize: 20),
                  ));
            } else if (gffft.rareFruits > 0) {
              // using the ultra rare marker for both right now
              // so it is just on the right side which looks better
              ultraRareFruitMarker = const Flexible(
                  flex: 3,
                  child: Text(
                    "RARE\nFRUIT",
                    style: TextStyle(fontFamily: 'SharpieStylie', color: Colors.yellow, fontSize: 20),
                  ));
            }
          }

          // hack until drop downs are internationalized
          if (boardWhoCanPost == "owner") {
            boardWhoCanPost = "just you";
          }
          if (boardWhoCanView == "owner") {
            boardWhoCanView = "just you";
          }
          if (calendarWhoCanPost == "owner") {
            calendarWhoCanPost = "just you";
          }
          if (calendarWhoCanView == "owner") {
            calendarWhoCanView = "just you";
          }
          if (galleryWhoCanPost == "owner") {
            galleryWhoCanPost = "just you";
          }
          if (galleryWhoCanView == "owner") {
            galleryWhoCanView = "just you";
          }
          if (notebookWhoCanPost == "owner") {
            notebookWhoCanPost = "just you";
          }
          if (notebookWhoCanView == "owner") {
            notebookWhoCanView = "just you";
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
                    height: 400,
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
                                        l10n.gffftSettingsHead,
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
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                            l10n.gffftSettingsEnabledHint,
                                            style: theme.textTheme.bodyText1,
                                            softWrap: true,
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            l10n.gffftSettingsEnableMembership,
                                            style: theme.textTheme.bodyText1,
                                          ),
                                          Switch(
                                            value: gffft?.allowMembers ?? false,
                                            onChanged: (value) {
                                              GffftPatchSave gffft = GffftPatchSave(
                                                uid: widget.uid,
                                                gid: widget.gid,
                                                allowMembers: value,
                                              );

                                              gffftApi.savePartial(gffft).then((value) => {
                                                    setState(() {
                                                      _loadGffft();
                                                    })
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                            l10n.gffftSettingsEnableMembershipHint,
                                            style: theme.textTheme.bodyText1,
                                            softWrap: true,
                                          ))
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
                                padding: EdgeInsets.all(10),
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.commentAlt),
                                    color: const Color(0xFF9970A9),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n.gffftHomeBoard,
                                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        l10n.gffftSettingsEnableMessageBoardHint,
                                        style: theme.textTheme.bodyText1,
                                        softWrap: true,
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsEnableMessageBoard,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Switch(
                                        value: boardEnabled,
                                        onChanged: (value) {
                                          GffftPatchSave gffft = GffftPatchSave(
                                            uid: widget.uid,
                                            gid: widget.gid,
                                            boardEnabled: value,
                                          );

                                          gffftApi.savePartial(gffft).then((value) => {
                                                setState(() {
                                                  _loadGffft();
                                                })
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanView,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanView,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanPost,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanPost,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  )
                                ])),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color(0xFF9970A9),
                                  width: 1.0,
                                )),
                          ),
                          Card(
                            margin: const EdgeInsets.all(8),
                            color: theme.backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color(0xFFB56277),
                                  width: 1.0,
                                )),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.calendarAlt),
                                    color: const Color(0xFFB56277),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n.gffftHomeCalendar,
                                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFB56277)),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        l10n.gffftSettingsEnableCalendarHint,
                                        style: theme.textTheme.bodyText1,
                                        softWrap: true,
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsEnableCalendar,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Switch(
                                        value: gffft?.hasFeature('calendar') ?? false,
                                        onChanged: (value) {
                                          GffftPatchSave gffft = GffftPatchSave(
                                            uid: widget.uid,
                                            gid: widget.gid,
                                            calendarEnabled: value,
                                          );

                                          gffftApi.savePartial(gffft).then((value) => {
                                                setState(() {
                                                  _loadGffft();
                                                })
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanView,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanView,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanPost,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanPost,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  )
                                ])),
                          ),
                          Card(
                            margin: const EdgeInsets.all(8),
                            color: theme.backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color(0xFF00829C),
                                  width: 1.0,
                                )),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.photoVideo),
                                    color: const Color(0xFF00829C),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n.gffftHomeGallery,
                                    style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF00829C)),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        l10n.gffftSettingsGalleryEnableHint,
                                        style: theme.textTheme.bodyText1,
                                        softWrap: true,
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsGalleryEnable,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Switch(
                                        value: galleryEnabled,
                                        onChanged: (value) {
                                          GffftPatchSave gffft = GffftPatchSave(
                                            uid: widget.uid,
                                            gid: widget.gid,
                                            galleryEnabled: value,
                                          );

                                          gffftApi.savePartial(gffft).then((value) => {
                                                setState(() {
                                                  _loadGffft();
                                                })
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanView,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanView,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsBoardWhoCanPost,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: boardWhoCanPost,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  )
                                ])),
                          ),
                          Card(
                            margin: const EdgeInsets.all(8),
                            color: theme.backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.deepOrangeAccent,
                                  width: 1.0,
                                )),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.fileAlt),
                                    color: Colors.deepOrangeAccent,
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n.gffftHomePages,
                                    style: theme.textTheme.headline6?.copyWith(color: Colors.deepOrangeAccent),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        l10n.gffftSettingsNotebookEnableHint,
                                        style: theme.textTheme.bodyText1,
                                        softWrap: true,
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsNotebookEnable,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Switch(
                                        value: notebookEnabled,
                                        onChanged: (value) {
                                          GffftPatchSave gffft = GffftPatchSave(
                                            uid: widget.uid,
                                            gid: widget.gid,
                                            notebookEnabled: value,
                                          );

                                          gffftApi.savePartial(gffft).then((value) => {
                                                setState(() {
                                                  _loadGffft();
                                                })
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsNotebookWhoCanView,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: notebookWhoCanView,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.gffftSettingsNotebookWhoCanEdit,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: DropdownButton<String>(
                                            value: notebookWhoCanPost,
                                            items: <String>['just you', 'admins', 'moderators', 'members', 'public']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (_) {},
                                          )),
                                    ],
                                  )
                                ])),
                          ),
                          Card(
                            margin: const EdgeInsets.all(8),
                            color: theme.backgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.green,
                                  width: 1.0,
                                )),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 300,
                                width: 300,
                                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.lemon),
                                    color: Colors.green,
                                    onPressed: () {},
                                  ),
                                  Text(
                                    l10n.gffftSettingsFruitCode,
                                    style: theme.textTheme.headline6?.copyWith(color: Colors.green),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        l10n.gffftSettingsFruitCodeHint,
                                        style: theme.textTheme.bodyText1,
                                        softWrap: true,
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      rareFruitMarker,
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: GridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: 3,
                                            children: getFruitCode(context, gffft),
                                          )),
                                      ultraRareFruitMarker,
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: shareText)).then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(l10n.gffftSettingsFruitCodeCopied)));
                                      });
                                    },
                                    child: Text(l10n.gffftSettingsFruitCodeCopy),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      GffftPatchSave gffft = GffftPatchSave(
                                        uid: widget.uid,
                                        gid: widget.gid,
                                        fruitCodeReset: true,
                                      );

                                      gffftApi.savePartial(gffft).then((value) => {
                                            setState(() {
                                              _loadGffft();
                                            })
                                          });
                                    },
                                    child: Text("generate new fruit code"),
                                  )
                                ])),
                          ),
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