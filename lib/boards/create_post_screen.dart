import 'package:card_settings/widgets/action_fields/card_settings_button.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_paragraph.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gffft/gfffts/models/gffft_minimal.dart';

class CreatePostScreen extends StatefulWidget {
  final void Function(String subject, String body) onSaved;

  const CreatePostScreen({Key? key, required this.gffft, required this.onSaved}) : super(key: key);

  final GffftMinimal gffft;

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _subject = TextEditingController();
  final _body = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future savePressed() async {
    widget.onSaved(_subject.text, _body.text);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.gffft.name, style: theme.textTheme.headline1),
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
