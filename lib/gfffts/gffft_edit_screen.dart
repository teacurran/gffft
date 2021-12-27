import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GffftEditScreen extends StatelessWidget {
  static const String id = 'Gffft Edit';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? title = "Spheria";
  String? author = "Cody Leet";
  String? url = "http://www.codyleet.com/spheria";

  @override
  Widget build(BuildContext context) {
    var i10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          i10n!.host,
          style: theme.textTheme.headline1,
        ),
        backgroundColor: theme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: CardSettings(
            showMaterialonIOS: true, // default is false
            children: <CardSettingsSection>[
              CardSettingsSection(
                header: CardSettingsHeader(
                  label: 'Favorite Book',
                ),
                children: <CardSettingsWidget>[
                  CardSettingsText(
                    label: 'Title',
                    initialValue: "title",
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Title is required.';
                    },
                    onSaved: (value) => title = value,
                  ),
                  CardSettingsText(
                    label: 'URL',
                    initialValue: url,
                    validator: (value) {
                      if (value != null && !value.startsWith('http:')) return 'Must be a valid website.';
                    },
                    onSaved: (value) => url = value,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
