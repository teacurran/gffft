import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/boards/board_api.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';

import 'create_post_screen.dart';
import 'models/post.dart';

final getIt = GetIt.instance;

class BoardViewScreen extends StatefulWidget {
  const BoardViewScreen({Key? key, required this.gffft, required this.bid}) : super(key: key);

  final GffftMinimal gffft;
  final String bid;

  @override
  _BoardViewScreen createState() => _BoardViewScreen();
}

class _BoardViewScreen extends State<BoardViewScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    BoardApi boardApi = getIt<BoardApi>();

    Future _handlePost(String subject, String body) async {
      print("handlePost: $subject, $body");

      setState(() {
        isLoading = true;
      });

      Post post = Post(widget.gffft.uid, widget.gffft.gid, widget.bid, body, subject: subject);
      await boardApi.createPost(post);
      print("post sent!");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gffft.name),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.secondaryHeaderColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: theme.focusColor),
            tooltip: l10n!.boardViewActionTooltip,
            backgroundColor: theme.primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(
                      gffft: widget.gffft,
                      onSaved: _handlePost,
                    ),
                  ));
            }),
        body: const Padding(padding: EdgeInsets.all(16.0), child: CustomScrollView()));
  }
}
