import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/fruit_code_edit_card.dart';
import 'package:gffft/gfffts/gffft_edit_card.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/users/user_api.dart';

import '../boards/board_edit_card.dart';
import '../galleries/gallery_edit_card.dart';
import '../link_sets/link_set_edit_card.dart';
import '../notebooks/notebook_edit_card.dart';
import 'gffft_api.dart';
import 'gffft_search_card.dart';
import 'models/gffft.dart';

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
    return FloatingActionButton(
        child: const Icon(Icons.save, color: Colors.black),
        backgroundColor: const Color(0xFFFABB59),
        onPressed: () => Navigator.of(context).pop());
  }

  void onSaveComplete() {
    print("onsavecomplete!!!");
    setState(() {
      _loadGffft();
    });
  }

  List<Widget> getEditCards(Gffft? gffft) {
    if (gffft == null) {
      return [];
    }
    return [
      GffftEditCard(
        gffft: gffft,
        onSaveComplete: onSaveComplete,
      ),
      BoardEditCard(
        gffft: gffft,
        onSaveComplete: onSaveComplete,
      ),
      GalleryEditCard(gffft: gffft, onSaveComplete: onSaveComplete),
      LinkSetEditCard(gffft: gffft, onSaveComplete: onSaveComplete),
      if (false) NotebookEditCard(gffft: gffft, onSaveComplete: onSaveComplete),
      FruitCodeEditCard(gffft: gffft, onSaveComplete: onSaveComplete),
      GffftSearchCard(
        gffft: gffft,
        onSaveComplete: onSaveComplete,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          var gffft = snapshot.data;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  l10n!.gffftSettingsHead,
                  style: theme.textTheme.headline1,
                ),
                centerTitle: true,
              ),
              body: Column(children: [
                SizedBox(
                    height: 400,
                    child: PageView(
                        physics: const PageScrollPhysics(),
                        controller: PageController(viewportFraction: 0.8),
                        children: getEditCards(gffft)))
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
