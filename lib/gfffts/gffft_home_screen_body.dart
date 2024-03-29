import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_home_card.dart';
import 'package:gffft/common/dates.dart';
import 'package:gffft/galleries/gallery_home_card.dart';
import 'package:gffft/gfffts/gffft_join_screen.dart';
import 'package:gffft/gfffts/gffft_membership_screen.dart';
import 'package:gffft/style/app_theme.dart';

import '../link_sets/link_set_home_card.dart';
import '../users/user_api.dart';
import 'fruit_code_home_card.dart';
import 'gffft_api.dart';
import 'gffft_feature_screen.dart';
import 'models/gffft.dart';

final getIt = GetIt.instance;

class GffftHomeScreenBody extends StatelessWidget {
  final defaultId = "{default}";
  final Gffft gffft;
  final VoidCallback onGffftChange;
  final UserApi userApi = getIt<UserApi>();
  final GffftApi gffftApi = getIt<GffftApi>();

  GffftHomeScreenBody({Key? key, required this.gffft, required this.onGffftChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    var children = <Widget>[];

    String name = "${gffft.name}";
    if (name == defaultId) {
      name = "My gffft";
    }
    children.add(SelectableText(
      name,
      style: theme.textTheme.headline1,
    ));

    if (gffft.intro != null) {
      String introText = "${gffft.intro}";
      if (introText == defaultId) {
        introText = l10n!.gffftIntro;
      }
      children.add(Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          child: SelectableText(
            introText,
            style: theme.textTheme.bodyText1?.copyWith(fontSize: 20),
          )));
    }

    children.addAll(getActions(context, l10n!, theme, gffft));

    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children));
  }

  List<Widget> getActions(BuildContext context, AppLocalizations l10n, ThemeData theme, Gffft gffft) {
    var actions = <Widget>[];

    gffft.features?.forEach((featureRef) {
      if (featureRef.type == "board" && featureRef.id != null) {
        actions.add(BoardHomeCard(gffft: gffft, featureRef: featureRef));
      } else if (featureRef.type == "gallery") {
        actions.add(GalleryHomeCard(gffft: gffft, featureRef: featureRef));
      } else if (featureRef.type == "linkSet") {
        actions.add(LinkSetHomeCard(
          gffft: gffft,
          featureRef: featureRef,
        ));
      } else if (featureRef.type == "fruitCode") {
        actions.add(FruitCodeHomeCard(
          gffft: gffft,
        ));
      }
    });

    actions.add(getMembershipCard(context, l10n, theme, gffft));

    return actions;
  }

  Widget getMembershipCard(BuildContext context, AppLocalizations l10n, ThemeData theme, Gffft gffft) {
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
          if (gffft.membership == null || gffft.membership?.type == "anon") {
            final snackBar = SnackBar(
              content: SelectableText(l10n.errorYouMustBeSignedInForThat),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          await userApi.bookmarkGffft(gffft.uid, gffft.gid).then((value) => {onGffftChange()});
        },
        child: const Icon(Icons.bookmark_add_outlined, color: Color(0xFFFFDC56)),
        style: theme.outlinedButtonTheme.style,
      ));
    } else {
      memberActions.add(OutlinedButton(
        onPressed: () async {
          await userApi.unBookmarkGffft(gffft.uid, gffft.gid).then((value) => {onGffftChange()});
        },
        child: const Icon(Icons.bookmark_remove, color: Color(0xFFFFDC56)),
        style: theme.outlinedButtonTheme.style,
      ));
    }

    memberActions.add(const SizedBox(width: 5));
    if (gffft.membership == null || gffft.membership?.type == "anon") {
      memberActions.add(OutlinedButton(
        style: theme.outlinedButtonTheme.style,
        onPressed: () async {
          if (gffft.me == null) {
            const snackBar = SnackBar(
              content: Text('You must be signed in for that'),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GffftJoinScreen(uid: gffft.uid, gid: gffft.gid);
          })).then((value) {
            onGffftChange;
          });
        },
        child: Padding(padding: const EdgeInsets.fromLTRB(0, 3, 0, 3), child: Text(l10n.gffftHomeJoin)),
      ));
    } else {
      memberActions.add(OutlinedButton(
        child: const Icon(Icons.account_box, color: Color(0xFFFFDC56)),
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GffftMembershipScreen(uid: gffft.uid, gid: gffft.gid);
          })).then((value) {
            onGffftChange();
          });
        },
        style: theme.outlinedButtonTheme.style,
      ));
    }

    memberActions.add(const SizedBox(width: 5));
    if (gffft.membership?.type == "owner") {
      memberActions.add(OutlinedButton(
        child: const Hero(tag: "settings-button", child: Icon(Icons.settings, color: Color(0xFFFFDC56))),
        onPressed: () {
          // VxNavigator.of(context)
          //     .waitAndPush(
          //         Uri(path: "/" + Uri(pathSegments: ["users", gffft.uid, "gfffts", gffft.gid, "features"]).toString()))
          //     .then((value) {
          //   onGffftChange();
          // });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GffftFeatureScreen(uid: gffft.uid, gid: gffft.gid);
          })).then((value) {
            onGffftChange();
          });
        },
        style: theme.outlinedButtonTheme.style,
      ));
    }

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
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
}
