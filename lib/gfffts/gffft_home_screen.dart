import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/users/user_api.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gffft_api.dart';
import 'gffft_home_screen_body.dart';
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
  final defaultId = "{default}";

  UserApi userApi = getIt<UserApi>();
  GffftApi gffftApi = getIt<GffftApi>();
  Future<Gffft?>? gffft;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "gffft_home");
    _loadGffft();
  }

  Future<void> _loadGffft() async {
    if (kDebugMode) {
      print("_loadGffft() called");
    }
    return setState(() {
      gffft = userApi.getGffftIfLoggedIn(widget.uid, widget.gid).then((gffft) {
        return gffft;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            screenBody = GffftHomeScreenBody(gffft: gffft, onGffftChange: _loadGffft);
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
                  onRefresh: _loadGffft,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: screenBody,
                  )),
            ),
          );
        });
  }
}
