import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/screens/login_screen.dart';
import 'package:gffft/users/user_api.dart';

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

    _loadGffft();
  }

  Future<void> _loadGffft() async {
    await FirebaseAnalytics.instance.setCurrentScreen(screenName: "gffft_home");
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
    return FutureBuilder(
        future: gffft,
        builder: (context, AsyncSnapshot<Gffft?> snapshot) {
          Widget screenBody = Container();

          var title = "connecting";
          if (snapshot.hasError) {
            title = "error";
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var gffft = snapshot.data;
            if (gffft == null) {
              screenBody = LoginScreen(onLogin: _loadGffft);
            } else {
              screenBody = RefreshIndicator(
                  onRefresh: _loadGffft,
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: GffftHomeScreenBody(gffft: gffft, onGffftChange: _loadGffft)));
            }
          } else {
            screenBody = Center(
                child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: const [SizedBox(height: 50, width: 50, child: CircularProgressIndicator())],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
            ));
          }

          return screenBody;
        });
  }
}
