import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/models/board.dart';
import 'package:gffft/common/dates.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gffft_api.dart';
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
  GffftApi gffftApi = getIt<GffftApi>();

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

    String membershipStatus = l10n.gffftHomeNotMember;
    String memberSince = "";
    if (gffft.membership != null) {
      membershipStatus = "${gffft.membership?.type}";
      memberSince = l10n.gffftHomeMemberSince(DATE_FORMAT_EU.format(gffft.membership!.createdAt));
    }

    var memberActions = <Widget>[];

    if (gffft.membership?.type != "owner") {
      if (gffft.membership == null) {
        memberActions.add(TextButton(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
          onPressed: () async {
            await gffftApi.joinGffft(widget.uid, widget.gid).then((value) => {_loadData()});
          },
          child: Text(l10n.gffftHomeJoin),
        ));
      } else {
        memberActions.add(TextButton(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
          onPressed: () async {
            await gffftApi.quitGffft(widget.uid, widget.gid).then((value) => {_loadData()});
          },
          child: Text(l10n.gffftHomeQuit),
        ));
      }
    }

    if (gffft.bookmark == null) {
      memberActions.add(TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
        onPressed: () async {
          await userApi.bookmarkGffft(widget.uid, widget.gid).then((value) => {_loadData()});
        },
        child: Text(l10n.gffftHomeBookmark),
      ));
    } else {
      memberActions.add(TextButton(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFDC56))),
        onPressed: () async {
          await userApi.unBookmarkGffft(widget.uid, widget.gid).then((value) => {_loadData()});
        },
        child: Text(l10n.gffftHomeUnBookmark),
      ));
    }

    actions.add(Card(
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
                  VerticalDivider(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: memberActions)
                ])))));

    if (gffft.features == null) {
      return actions;
    }

    gffft.features?.forEach((featureRef) {
      if (featureRef.type == "board" && featureRef.id != null) {
        int threadCount;
        int postCount;
        Board? board;
        if (gffft.boards != null) {
          for (var b in gffft.boards!) {
            if (b.id == featureRef.id) {
              board = b;
              threadCount = b.threads;
              postCount = b.posts;
            }
          }
        }

        if (board != null) {
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
                                onPressed: () {},
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
                                  Row(children: [SelectableText("threads:"), SelectableText(board.threads.toString())]),
                                  Row(children: [SelectableText("posts:"), SelectableText(board.posts.toString())]),
                                ])
                          ]))))));
        }
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
                  VxNavigator.of(context).push(
                      Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "galleries", featureRef.id!]));
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
                                icon: const FaIcon(FontAwesomeIcons.fileAlt),
                                color: const Color(0xFFFABB59),
                                onPressed: () async {}),
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
