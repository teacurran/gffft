import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/style/app_theme.dart';

import '../gfffts/gffft_api.dart';
import '../gfffts/models/gffft.dart';
import '../gfffts/models/gffft_patch_save.dart';

final getIt = GetIt.instance;

class FruitCodeEditCard extends StatelessWidget {
  const FruitCodeEditCard({Key? key, required this.gffft, this.onSaveComplete}) : super(key: key);

  final Gffft gffft;
  final VoidCallback? onSaveComplete;

  List<Widget> getFruitCode(BuildContext context, Gffft? gffft) {
    final theme = context.appTheme.materialTheme;
    var widgets = <Widget>[];

    if (gffft != null) {
      for (var fruit in gffft.fruitCode) {
        widgets.add(Text(
          fruit,
          style: theme.textTheme.bodyText1!.copyWith(fontSize: 20),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final ThemeData theme = context.appTheme.materialTheme;
    GffftApi gffftApi = getIt<GffftApi>();

    bool fruitCodeEnabled = false;
    if (gffft.hasFeature("fruitCode")) {
      fruitCodeEnabled = true;
    }

    Widget rareFruitMarker = Flexible(child: Container());
    Widget ultraRareFruitMarker = Flexible(child: Container());
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

    var shareText = "${l10n!.gffftSettingsFruitCodeShare}\n";

    shareText = shareText + "${gffft.fruitCode[0]}${gffft.fruitCode[1]}${gffft.fruitCode[2]}\n";
    shareText = shareText + "${gffft.fruitCode[3]}${gffft.fruitCode[4]}${gffft.fruitCode[5]}\n";
    shareText = shareText + "${gffft.fruitCode[6]}${gffft.fruitCode[7]}${gffft.fruitCode[8]}\n";

    return SingleChildScrollView(
        child: Card(
      elevation: 0,
      margin: const EdgeInsets.all(8),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.green,
            width: 1.0,
          )),
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 350,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.lemon),
                color: Colors.green,
                onPressed: () {},
              ),
              Text(
                l10n.gffftSettingsFruitCode,
                style: theme.textTheme.headline6?.copyWith(color: Colors.green),
              )
            ]),
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
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: shareText)).then((_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(l10n.gffftSettingsFruitCodeCopied)));
                      });
                    },
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: getFruitCode(context, gffft),
                        ))),
                ultraRareFruitMarker,
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              OutlinedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: shareText)).then((_) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(l10n.gffftSettingsFruitCodeCopied)));
                  });
                },
                child: Icon(Icons.copy, color: theme.primaryColor),
              ),
              OutlinedButton(
                onPressed: () {
                  GffftPatchSave gffft = GffftPatchSave(
                    uid: this.gffft.uid,
                    gid: this.gffft.gid,
                    fruitCodeReset: true,
                  );

                  gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                },
                child: Icon(Icons.refresh, color: theme.primaryColor),
              )
            ]),
            Row(
              children: [
                Text(
                  l10n.gffftSettingsFruitCodeEnable,
                  style: theme.textTheme.bodyText1,
                ),
                Switch(
                  value: fruitCodeEnabled,
                  onChanged: (value) {
                    GffftPatchSave gffft = GffftPatchSave(
                      uid: this.gffft.uid,
                      gid: this.gffft.gid,
                      fruitCodeEnabled: value,
                    );

                    gffftApi.savePartial(gffft).then((value) => onSaveComplete!());
                  },
                )
              ],
            ),
          ])),
    ));
  }
}
