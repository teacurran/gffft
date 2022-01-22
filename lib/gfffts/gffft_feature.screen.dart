import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gffft_api.dart';
import 'models/gffft.dart';

final getIt = GetIt.instance;

class GffftFeatureScreen extends StatefulWidget {
  const GffftFeatureScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

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
    return FloatingActionButton(
        child: Icon(Icons.add, color: theme.focusColor),
        tooltip: l10n!.boardViewActionTooltip,
        backgroundColor: theme.primaryColor,
        onPressed: () {
          VxNavigator.of(context).pop();
        });
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Card(child: Text('Carousel $carouselIndex'));
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }

  int _index = 0;

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
              name = "${gffft.me.username}'s gffft";
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
              body: Center(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Card(
                          margin: EdgeInsets.all(8),
                          color: theme.backgroundColor,
                          child: Container(
                              height: 300,
                              width: 300,
                              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.commentAlt),
                                  color: const Color(0xFF9970A9),
                                  onPressed: () {},
                                ),
                                Text(
                                  l10n!.gffftHomeBoard,
                                  style: theme.textTheme.headline6?.copyWith(color: const Color(0xFF9970A9)),
                                )
                              ])),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                color: Color(0xFF9970A9),
                                width: 1.0,
                              )),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          color: Colors.blue,
                          child: Text("blue"),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          height: 200,
                          width: 200,
                          color: Colors.green,
                          child: Text("green"),
                        )
                      ]))),
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
