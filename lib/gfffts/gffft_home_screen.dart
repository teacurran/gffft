import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_view_screen.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'models/gffft.dart';

final getIt = GetIt.instance;

class GffftHomeScreen extends StatefulWidget {
  const GffftHomeScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

  @override
  _GffftHomeScreenState createState() => _GffftHomeScreenState();
}

class _GffftHomeScreenState extends State<GffftHomeScreen> {
  UserApi userApi = getIt<UserApi>();

  Future<Gffft>? gffft;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      gffft = userApi.getGffft(widget.uid, widget.gid);
    });
  }

  List<Widget> getActions(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    var actions = <Widget>[];

    if (gffft.features == null) {
      return actions;
    }

    gffft.features?.forEach((featureRef) {
      if (featureRef.type == "board" && featureRef.id != null) {
        actions.add(Card(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            clipBehavior: Clip.antiAlias,
            color: theme.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color(0xFF9970A9),
                  width: 1.0,
                )),
            child: InkWell(
                onTap: () {
                  VxNavigator.of(context)
                      .push(Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", featureRef.id!]));
                },
                splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                highlightColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                    child: SizedBox(
                        width: double.infinity,
                        child: Row(children: [
                          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.commentAlt),
                              color: const Color(0xFF9970A9),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BoardViewScreen(uid: widget.uid, gid: widget.gid, bid: featureRef.id!),
                                  ),
                                );
                              },
                            ),
                            Text(
                              l10n.gffftHomeBoard,
                              style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
                            )
                          ]),
                          VerticalDivider(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: [SelectableText("threads:"), SelectableText("4923")]),
                                Row(children: [SelectableText("posts:"), SelectableText("983917")]),
                              ])
                        ]))))));
      } else if (featureRef.type == "calendar") {
        actions.add(Card(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            clipBehavior: Clip.antiAlias,
            color: theme.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color(0xFFB56277),
                  width: 1.0,
                )),
            child: InkWell(
                onTap: () {
                  VxNavigator.of(context)
                      .push(Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", featureRef.id!]));
                },
                splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                highlightColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                    child: SizedBox(
                        width: double.infinity,
                        child: Row(children: [
                          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            IconButton(
                                icon: FaIcon(FontAwesomeIcons.calendarAlt), onPressed: () {}, color: Color(0xFFB56277)),
                            Text(
                              l10n.gffftHomeCalendar,
                              style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFB56277)),
                            )
                          ]),
                          VerticalDivider(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: [SelectableText("future events:"), SelectableText("45")]),
                                Row(children: [SelectableText("past events:"), SelectableText("32")]),
                              ])
                        ]))))));
      } else if (featureRef.type == "gallery") {
        actions.add(Card(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            clipBehavior: Clip.antiAlias,
            color: theme.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color(0xFF00829C),
                  width: 1.0,
                )),
            child: InkWell(
                onTap: () {
                  VxNavigator.of(context)
                      .push(Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", featureRef.id!]));
                },
                splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                highlightColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                    child: SizedBox(
                        width: double.infinity,
                        child: Row(children: [
                          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.photoVideo,
                                color: Color(0xFF00829C),
                              ),
                              onPressed: () {},
                            ),
                            Text(
                              l10n.gffftHomeMedia,
                              style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF00829C)),
                            )
                          ]),
                          VerticalDivider(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: [SelectableText("photos:"), SelectableText("2938")]),
                                Row(children: [SelectableText("videos:"), SelectableText("14")]),
                              ])
                        ]))))));
      } else if (featureRef.type == "notebook") {
        actions.add(Card(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            clipBehavior: Clip.antiAlias,
            color: theme.backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color(0xFFFABB59),
                  width: 1.0,
                )),
            child: InkWell(
                onTap: () {
                  VxNavigator.of(context)
                      .push(Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", featureRef.id!]));
                },
                splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
                highlightColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                    child: SizedBox(
                        width: double.infinity,
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.penNib),
                              color: const Color(0xFFFABB59),
                              onPressed: () {},
                            ),
                            Text(
                              l10n.gffftHomePages,
                              style: theme.textTheme.headline6?.copyWith(color: const Color(0xFFFABB59)),
                            )
                          ]),
                          VerticalDivider(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(children: [SelectableText("pages:"), SelectableText("38")]),
                                Row(children: [SelectableText("edits:"), SelectableText("297")]),
                              ])
                        ]))))));
      }
    });

    return actions;
  }

  Widget getGffftScreen(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    var children = <Widget>[
      SelectableText(
        gffft.name ?? l10n.loading,
        style: theme.textTheme.headline1,
      )
    ];
    if (gffft.intro != null) {
      children.add(Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: ExpandableText(
            gffft.intro ?? l10n.loading,
            expandText: l10n.showMore,
            collapseText: l10n.showLess,
            maxLines: 8,
            linkColor: theme.textTheme.bodyText1?.color,
            style: theme.textTheme.bodyText1,
            textAlign: TextAlign.justify,
            animation: true,
          )));
    }

    children.addAll(getActions(l10n, theme, gffft));

    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children));
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
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: screenBody,
                  )),
            ),
          );
        });
  }
}
