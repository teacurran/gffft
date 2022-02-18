import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../gfffts/models/gffft.dart';

final getIt = GetIt.instance;

class FruitCodeHomeCard extends StatelessWidget {
  const FruitCodeHomeCard({Key? key, required this.gffft}) : super(key: key);

  final Gffft gffft;

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
    final theme = Theme.of(context);
    var l10n = AppLocalizations.of(context);

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

    return Card(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        clipBehavior: Clip.antiAlias,
        color: theme.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              color: Colors.green,
              width: 1.0,
            )),
        child: InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: shareText)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.gffftSettingsFruitCodeCopied)));
              });
            },
            splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(.25),
            highlightColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(children: [
                    rareFruitMarker,
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: getFruitCode(context, gffft),
                        )),
                    ultraRareFruitMarker
                  ]),
                ))));
  }
}
