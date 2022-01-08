import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_view_screen.dart';
import 'package:gffft/users/user_api.dart';

import 'models/gffft.dart';
import 'models/gffft_minimal.dart';

final getIt = GetIt.instance;

class GffftHomeScreen extends StatefulWidget {
  const GffftHomeScreen({Key? key, required this.gffft}) : super(key: key);

  final GffftMinimal gffft;

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
      gffft = userApi.getGffft(widget.gffft.uid, widget.gffft.gid);
    });
  }

  List<Widget> getActions(AppLocalizations l10n, ThemeData theme) {
    var actions = <Widget>[];

    actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: const FaIcon(FontAwesomeIcons.penNib),
        onPressed: () {},
      ),
      Text(
        l10n!.gffftHomeBlog,
        style: theme.textTheme.headline6?.copyWith(color: theme.primaryColor),
      )
    ]));

    actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: const FaIcon(FontAwesomeIcons.commentAlt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoardViewScreen(gffft: widget.gffft, bid: "0"),
            ),
          );
        },
      ),
      Text(
        l10n.gffftHomeBlog,
        style: theme.textTheme.headline6?.copyWith(color: theme.primaryColor),
      )
    ]));

    actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: const FaIcon(FontAwesomeIcons.photoVideo),
        onPressed: () {},
      ),
      Text(
        l10n.gffftHomeMedia,
        style: theme.textTheme.headline6,
      )
    ]));

    actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: const FaIcon(FontAwesomeIcons.fileAlt),
        onPressed: () {},
      ),
      Text(
        l10n.editPages,
        style: theme.textTheme.headline6,
      )
    ]));

    actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: FaIcon(FontAwesomeIcons.calendarAlt),
        onPressed: () {},
      ),
      Text(
        l10n.gffftHomeCalendar,
        style: theme.textTheme.headline6,
      )
    ]));
    return actions;
  }

  Widget getGffftScreen(AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            SliverToBoxAdapter(
                child: Card(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    color: theme.primaryColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                      child: Text(
                        gffft.name ?? "",
                        style: theme.textTheme.headline4,
                      ),
                    ))),
            SliverToBoxAdapter(
                child: Wrap(
              spacing: 10,
              children: getActions(l10n, theme),
            )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          var children = <Widget>[];
          var title = "connecting";

          if (snapshot.hasError) {
            title = "error";
          }

          var gffft = snapshot.data;

          if (gffft != null) {
            title = gffft.name ?? "unknown name";

            children.add(getGffftScreen(l10n!, theme, gffft));
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    title,
                    style: theme.textTheme.headline1,
                  ),
                  backgroundColor: theme.backgroundColor,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children)),
              ),
            ),
          );
        });
  }
}
