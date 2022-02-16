import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_home_card.dart';
import 'package:gffft/calendars/calendar_home_card.dart';
import 'package:gffft/common/dates.dart';
import 'package:gffft/galleries/gallery_home_card.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import '../link_sets/link_set_home_card.dart';
import '../notebooks/notebook_home_card.dart';
import 'gffft_api.dart';
import 'models/gffft.dart';
import 'models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class GffftHomeScreen extends StatefulWidget {
  const GffftHomeScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

  @override
  _GffftHomeScreenState createState() => _GffftHomeScreenState();
}

class _GffftHomeScreenState extends State<GffftHomeScreen> {
  final defaultId = "{default}";

  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  Future<Gffft>? gffft;

  bool editing = false;

  bool editingTitle = false;
  late TextEditingController _titleController;

  bool editingIntro = false;
  late TextEditingController _introController;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "gffft_home");
    _loadGffft();
  }

  Future<void> _loadGffft() async {
    if (kDebugMode) {
      print("_loadGffft() called");
    }
    return setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid).then((gffft) {
        _titleController = TextEditingController(text: gffft.name);
        _introController = TextEditingController(text: gffft.intro);
        return gffft;
      });
    });
  }

  Future<void> _toggleEditing() async {
    return setState(() {
      editing = editing ? false : true;
    });
  }

  Future<void> _toggleEditingIntro() async {
    return setState(() {
      editingIntro = editingIntro ? false : true;
    });
  }

  Future<void> _toggleEditingTitle() async {
    return setState(() {
      editingTitle = editingTitle ? false : true;
    });
  }

  Future<void> _saveIntroText() async {
    GffftPatchSave gffft = GffftPatchSave(
      uid: widget.uid,
      gid: widget.gid,
      intro: _introController.text,
    );

    gffftApi.savePartial(gffft).then((value) => {
          setState(() {
            _loadGffft();
            _toggleEditingIntro();
          })
        });
  }

  Future<void> _saveTitle() async {
    GffftPatchSave gffft = GffftPatchSave(
      uid: widget.uid,
      gid: widget.gid,
      name: _titleController.text,
    );

    gffftApi.savePartial(gffft).then((value) => {
          setState(() {
            _loadGffft();
            _toggleEditingTitle();
          })
        });
  }

  List<Widget> getActions(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    var actions = <Widget>[];

    gffft.features?.forEach((featureRef) {
      if (featureRef.type == "board" && featureRef.id != null) {
        actions.add(BoardHomeCard(gffft: gffft, featureRef: featureRef));
      } else if (featureRef.type == "calendar") {
        actions.add(CalendarHomeCard(gffft: gffft, featureRef: featureRef));
      } else if (featureRef.type == "gallery") {
        actions.add(GalleryHomeCard(gffft: gffft, featureRef: featureRef));
      } else if (featureRef.type == "notebook") {
        actions.add(NotebookHomeCard(
          gffft: gffft,
          featureRef: featureRef,
        ));
      } else if (featureRef.type == "linkSet") {
        actions.add(LinkSetHomeCard(
          gffft: gffft,
          featureRef: featureRef,
        ));
      }
    });

    actions.add(getMembershipCard(l10n, theme, gffft));

    return actions;
  }

  Widget getMembershipCard(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    String membershipStatus = l10n.gffftHomeNotMember;
    String memberSince = "";
    if (gffft.membership != null) {
      membershipStatus = "${gffft.membership?.type}";
      memberSince = l10n.gffftHomeMemberSince(DATE_FORMAT_EU.format(gffft.membership!.createdAt));
    }

    var memberActions = <Widget>[];

    if (gffft.bookmark == null) {
      memberActions.add(TextButton(
        onPressed: () async {
          await userApi.bookmarkGffft(widget.uid, widget.gid).then((value) => {_loadGffft()});
        },
        child: const Padding(
            padding: EdgeInsets.all(10), child: Icon(Icons.bookmark_add_outlined, color: Color(0xFFFFDC56))),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));
    } else {
      memberActions.add(TextButton(
        onPressed: () async {
          await userApi.unBookmarkGffft(gffft.uid, gffft.gid).then((value) => {_loadGffft()});
        },
        child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.bookmark_remove, color: Color(0xFFFFDC56))),
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));
    }

    memberActions.add(const SizedBox(width: 5));
    if (gffft.membership == null) {
      memberActions.add(TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
        onPressed: () async {
          VxNavigator.of(context)
              .waitAndPush(
                  Uri(path: "/" + Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "join"]).toString()))
              .then((value) {
            _loadGffft();
          });
        },
        child: Text(l10n.gffftHomeJoin),
      ));
    } else {
      memberActions.add(TextButton(
        child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.account_box, color: Color(0xFFFFDC56))),
        onPressed: () async {
          await _toggleEditing();
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));
    }

    memberActions.add(const SizedBox(width: 5));
    if (gffft.membership?.type == "owner") {
      memberActions.add(TextButton(
        child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.settings, color: Color(0xFFFFDC56))),
        onPressed: () async {
          await _toggleEditing();
        },
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));
    }

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: theme.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Color(0xFFFFDC56),
              width: 1.0,
            )),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
            child: SizedBox(
                width: double.infinity,
                child: Row(children: [
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SelectableText(
                      l10n.gffftHomeMembership,
                      style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFFDC56)),
                      textAlign: TextAlign.left,
                    ),
                    SelectableText(
                      membershipStatus,
                      style: theme.textTheme.subtitle2?.copyWith(color: const Color(0xFFFFDC56)),
                      textAlign: TextAlign.left,
                    ),
                    SelectableText(
                      memberSince,
                      style: theme.textTheme.subtitle2?.copyWith(color: const Color(0xFFFFDC56)),
                      textAlign: TextAlign.left,
                    )
                  ]),
                  const VerticalDivider(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: memberActions,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        )
                      ])
                ]))));
  }

  Widget getGffftScreen(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    var children = <Widget>[];

    String name = "${gffft.name}";
    if (name == defaultId) {
      name = "My gffft";
    }
    if (editing && editingTitle) {
      children.add(Focus(
          child: TextField(
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
            controller: _titleController,
            textInputAction: TextInputAction.go,
          ),
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _saveTitle();
            }
          }));
    } else {
      children.add(SelectableText(
        name,
        style: theme.textTheme.headline1,
        onTap: () async {
          await _toggleEditingTitle();
        },
      ));
    }
    if (gffft.intro != null) {
      String introText = "${gffft.intro}";
      if (introText == defaultId) {
        introText = l10n.gffftIntro;
      }
      if (editing && editingIntro) {
        children.add(Focus(
            child: TextField(
              style: theme.textTheme.bodyText1?.copyWith(fontSize: 20),
              controller: _introController,
              textInputAction: TextInputAction.go,
              maxLines: 5,
            ),
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                _saveIntroText();
              }
            }));
      } else {
        children.add(Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: SelectableText(
              introText,
              style: theme.textTheme.bodyText1?.copyWith(fontSize: 20),
              onTap: () async {
                await _toggleEditingIntro();
              },
            )));
      }
    }

    children.addAll(getActions(l10n, theme, gffft));

    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children));
  }

  Widget? getFloatingActionButton(BuildContext context) {
    if (!editing) {
      return null;
    }
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return FloatingActionButton(
        child: const Icon(Icons.settings, color: Colors.black),
        tooltip: l10n!.boardViewActionTooltip,
        backgroundColor: Color(0xFFFABB59),
        onPressed: () {
          VxNavigator.of(context)
              .waitAndPush(Uri(
                  path: "/" + Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "features"]).toString()))
              .then((value) {
            _loadGffft();
          });
        });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();

    super.dispose();
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

          var gffft = snapshot.data;
          if (gffft != null) {
            title = "";
            screenBody = getGffftScreen(l10n!, theme, gffft);
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
              body: RefreshIndicator(
                  onRefresh: _loadGffft,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: screenBody,
                  )),
              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              floatingActionButton: getFloatingActionButton(context),
            ),
          );
        });
  }
}
