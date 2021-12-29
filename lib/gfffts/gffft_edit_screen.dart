import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GffftEditScreen extends StatelessWidget {
  static const String id = 'Gffft Edit';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? gffftName;
  String? editDescription;
  List<String>? editTags = <String>[];

  bool editAllowMembers = false;
  bool editRequireApproval = false;
  bool editEnableAltHandles = false;

  bool editBoardEnabled = false;
  PickerModel? editBoardWhoCanView;
  PickerModel? editBoardWhoCanPost;

  bool editGalleryEnabled = false;
  PickerModel? editGalleryWhoCanView;
  PickerModel? editGalleryWhoCanPost;

  bool editPagesEnabled = false;
  PickerModel? editPagesWhoCanView;
  PickerModel? editPagesWhoCanEdit;

  List<String> allTags = <String>['farming', 'politics', 'culture', 'life'];

  List<PickerModel> _getMemberTypes(AppLocalizations? i10n) {
    return <PickerModel>[
      PickerModel(i10n?.memberTypeSysop ?? 'Sysop', code: 'sysop'),
      PickerModel(i10n?.memberTypeAdmin ?? 'Administrators', code: 'admin'),
      PickerModel(i10n?.memberTypeMember ?? 'Members', code: 'member'),
      PickerModel(i10n?.memberTypeAnon ?? 'Anonymous', code: 'anon')
    ];
  }

  List<PickerModel> _getSafeMemberTypes(AppLocalizations? i10n) {
    return <PickerModel>[
      PickerModel(i10n?.memberTypeSysop ?? 'Sysop', code: 'sysop'),
      PickerModel(i10n?.memberTypeAdmin ?? 'Administrators', code: 'admin'),
      PickerModel(i10n?.memberTypeMember ?? 'Members', code: 'member')
    ];
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? i10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    List<PickerModel> memberTypes = _getMemberTypes(i10n);
    List<PickerModel> safeMemberTypes = _getMemberTypes(i10n);

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
                  label: i10n.editYourGffftInfo,
                ),
                children: <CardSettingsWidget>[
                  CardSettingsText(
                    label: i10n.editName,
                    initialValue: gffftName,
                    validator: (value) {
                      if (value == null || value.isEmpty) return i10n.validateFieldIsRequired(i10n.editName);
                    },
                    onSaved: (value) => gffftName = value,
                    contentPadding: const EdgeInsets.all(8),
                    contentOnNewLine: true,
                  ),
                  CardSettingsText(
                    label: i10n.editDescription,
                    initialValue: editDescription,
                    validator: (value) {
                      if (value == null || value.isEmpty) return i10n.validateFieldIsRequired(i10n.editDescription);
                    },
                    onSaved: (value) => editDescription = value,
                    contentPadding: const EdgeInsets.all(8),
                    contentOnNewLine: true,
                    hintText: i10n.editDescriptionHint,
                  ),
                  CardSettingsCheckboxPicker<String>(
                    label: i10n.editTags,
                    initialItems: editTags,
                    items: allTags,
                    onSaved: (value) => editTags = value,
                  )
                ],
              ),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: i10n.editMembership,
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsSwitch(
                      label: i10n.editAllowMembers,
                      initialValue: editAllowMembers,
                      onChanged: (value) => editAllowMembers = value,
                      onSaved: (value) => editAllowMembers = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsSwitch(
                      label: i10n.editRequireApproval,
                      initialValue: editRequireApproval,
                      onChanged: (value) => editRequireApproval = value,
                      onSaved: (value) => editRequireApproval = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsInstructions(text: i10n.editRequireApprovalHint),
                    CardSettingsSwitch(
                      label: i10n.editEnableAltHandles,
                      initialValue: editEnableAltHandles,
                      onChanged: (value) => editEnableAltHandles = value,
                      onSaved: (value) => editEnableAltHandles = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsInstructions(text: i10n.editEnableAltHandlesHint)
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: i10n.editPages,
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsSwitch(
                      label: i10n.editEnabled,
                      initialValue: editPagesEnabled,
                      onChanged: (value) => editPagesEnabled = value,
                      onSaved: (value) => editPagesEnabled = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsListPicker<PickerModel>(
                        label: i10n.editPagesWhoCanView,
                        initialItem: editPagesWhoCanView ?? memberTypes[0],
                        items: memberTypes),
                    CardSettingsListPicker<PickerModel>(
                        label: i10n.editPagesWhoCanEdit,
                        initialItem: editPagesWhoCanEdit ?? safeMemberTypes[0],
                        items: safeMemberTypes)
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: i10n.editBoard,
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsSwitch(
                      label: i10n.editEnabled,
                      initialValue: editBoardEnabled,
                      onChanged: (value) => editBoardEnabled = value,
                      onSaved: (value) => editBoardEnabled = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsListPicker<PickerModel>(
                        label: i10n.editBoardWhoCanView,
                        initialItem: editBoardWhoCanView ?? memberTypes[0],
                        items: memberTypes),
                    CardSettingsListPicker<PickerModel>(
                        label: i10n.editBoardWhoCanPost,
                        initialItem: editBoardWhoCanPost ?? safeMemberTypes[0],
                        items: safeMemberTypes)
                  ]),
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: i10n.editGallery,
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsSwitch(
                      label: i10n.editEnabled,
                      initialValue: editGalleryEnabled,
                      onSaved: (value) => editGalleryEnabled = value ?? false,
                      trueLabel: i10n.yes,
                      falseLabel: i10n.no,
                    ),
                    CardSettingsListPicker<PickerModel>(
                      label: i10n.editBoardWhoCanView,
                      initialItem: editGalleryWhoCanView ?? memberTypes[1],
                      items: memberTypes,
                      onSaved: (value) => editGalleryWhoCanView = value,
                    ),
                    CardSettingsListPicker<PickerModel>(
                      label: i10n.editBoardWhoCanPost,
                      initialItem: editGalleryWhoCanPost ?? safeMemberTypes[0],
                      items: safeMemberTypes,
                      onSaved: (value) => editGalleryWhoCanPost = value,
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
