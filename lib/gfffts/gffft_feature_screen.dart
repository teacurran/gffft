import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/gfffts/fruit_code_edit_card.dart';
import 'package:gffft/gfffts/gffft_edit_card.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import '../boards/board_edit_card.dart';
import '../galleries/gallery_edit_card.dart';
import '../link_sets/link_set_edit_card.dart';
import '../notebooks/notebook_edit_card.dart';
import 'gffft_api.dart';
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
      NotebookEditCard(gffft: gffft, onSaveComplete: onSaveComplete),
      FruitCodeEditCard(gffft: gffft, onSaveComplete: onSaveComplete)
    ];
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

          var gffft = snapshot.data;
          if (gffft != null) {
            title = "";

            name = "${gffft.name}";
            if (name == defaultId) {
              name = "My gffft";
            }
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
