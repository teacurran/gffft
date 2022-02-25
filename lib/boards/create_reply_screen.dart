import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import 'board_api.dart';
import 'models/post_submit.dart';

final getIt = GetIt.instance;

class CreateReplyScreen extends StatefulWidget {
  const CreateReplyScreen({Key? key, required this.uid, required this.gid, required this.bid, required this.tid})
      : super(key: key);

  final String uid;
  final String gid;
  final String bid;
  final String tid;

  @override
  State<CreateReplyScreen> createState() => _CreateReplyScreenState();
}

class _CreateReplyScreenState extends State<CreateReplyScreen> {
  final _body = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future savePressed() async {
    BoardApi boardApi = getIt<BoardApi>();
    final body = _body.text;

    PostSubmit post = PostSubmit(widget.uid, widget.gid, widget.bid, body, tid: widget.tid);
    await boardApi.createPost(post);

    //VxNavigator.of(context).pop();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.gid, style: theme.textTheme.headline1),
          backgroundColor: theme.backgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: CardSettings(showMaterialonIOS: true, children: [
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: l10n!.boardReplyToThread,
                    color: theme.primaryColor,
                  ),
                  children: [
                    CardSettingsParagraph(
                      label: l10n.boardCreatePostBody,
                      contentOnNewLine: true,
                      maxLength: 1024,
                      controller: _body,
                    ),
                    CardSettingsButton(
                        backgroundColor: theme.backgroundColor,
                        label: l10n.boardCreatePostPost,
                        showMaterialonIOS: true,
                        onPressed: savePressed),
                  ]),
            ])));
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }
}
