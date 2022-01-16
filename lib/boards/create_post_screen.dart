import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:velocity_x/velocity_x.dart';

import 'board_api.dart';
import 'models/post_submit.dart';

final getIt = GetIt.instance;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key, required this.uid, required this.gid, required this.bid}) : super(key: key);

  final String uid;
  final String gid;
  final String bid;

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _subject = TextEditingController();
  final _body = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future savePressed() async {
    BoardApi boardApi = getIt<BoardApi>();
    final subject = _subject.text;
    final body = _body.text;
    print("handlePost: $subject, $body");

    PostSubmit post = PostSubmit(widget.uid, widget.gid, widget.bid, body, subject: subject);
    await boardApi.createPost(post);
    print("post sent!");

    //VxNavigator.of(context).pop();

    VxNavigator.of(context)
        .returnAndPush(Uri(pathSegments: ["users", widget.uid, "gfffts", widget.gid, "boards", widget.bid]));
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
                    label: l10n!.boardCreatePostTitle,
                    color: theme.primaryColor,
                  ),
                  children: [
                    CardSettingsText(
                      label: l10n.boardCreatePostSubject,
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.validateFieldIsRequired(l10n.editName);
                      },
                      contentPadding: const EdgeInsets.all(8),
                      contentOnNewLine: true,
                      maxLength: 128,
                      showCounter: true,
                      controller: _subject,
                    ),
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
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }
}
