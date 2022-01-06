import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gffft/boards/board_view_screen.dart';

import 'models/gffft_minimal.dart';

class GffftHomeScreen extends StatelessWidget {
  const GffftHomeScreen({Key? key, required this.gffft}) : super(key: key);

  final GffftMinimal gffft;

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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

    if (gffft.bid != null) {
      actions.add(Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.commentAlt),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoardViewScreen(gffft: gffft, bid: gffft.bid!),
              ),
            );
          },
        ),
        Text(
          l10n.gffftHomeBlog,
          style: theme.textTheme.headline6?.copyWith(color: theme.primaryColor),
        )
      ]));
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Text(gffft.name),
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
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
                          gffft.name,
                          style: theme.textTheme.headline4,
                        ),
                      ))),
              SliverToBoxAdapter(
                  child: Wrap(
                spacing: 10,
                children: actions,
              )),
            ],
          )),
    );
  }
}
