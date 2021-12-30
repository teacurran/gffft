import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:card_settings/widgets/card_settings_widget.dart';
import 'package:card_settings/widgets/information_fields/card_settings_header.dart';
import 'package:card_settings/widgets/text_fields/card_settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/ui/string_picker_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'gffft.dart';
import 'gffft_api.dart';

final getIt = GetIt.instance;

class GffftEditScreen extends StatefulWidget {
  const GffftEditScreen({Key? key}) : super(key: key);

  static const String id = 'Gffft Edit';

  @override
  _GffftEditScreen createState() => _GffftEditScreen();
}

class _GffftEditScreen extends State<GffftEditScreen> {
  GffftApi gffftApi = getIt<GffftApi>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool initialLoad = true;
  bool isLoading = false;
  String? errorLoading;

  String? gffftId;
  String? editName;
  String? editDescription;
  String? editIntro;
  List<String>? editTags = <String>[];
  bool editEnabled = false;

  bool editAllowMembers = false;
  bool editRequireApproval = false;
  bool editEnableAltHandles = false;

  bool editBoardEnabled = false;
  StringPickerModel? editBoardWhoCanView;
  StringPickerModel? editBoardWhoCanPost;

  bool editGalleryEnabled = false;
  StringPickerModel? editGalleryWhoCanView;
  StringPickerModel? editGalleryWhoCanPost;

  bool editPagesEnabled = false;
  StringPickerModel? editPagesWhoCanView;
  StringPickerModel? editPagesWhoCanEdit;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    gffftApi
        .getDefaultGffft()
        .then((gffft) => {
              setState(() {
                print("got gffft ${gffft.toJson()}");
                gffftId = gffft.id;
                editName = gffft.name;
                editDescription = gffft.description;
                editIntro = gffft.intro;
                initialLoad = false;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                print(error);
              })
            });
  }

  List<String> allTags = <String>['farming', 'politics', 'culture', 'life'];

  List<StringPickerModel> _getMemberTypes(AppLocalizations? i10n) {
    return <StringPickerModel>[
      StringPickerModel(i10n?.memberTypeSysop ?? 'SysopS', 'sysop'),
      StringPickerModel(i10n?.memberTypeAdmin ?? 'Administrators', 'admin'),
      StringPickerModel(i10n?.memberTypeMember ?? 'Members', 'member'),
      StringPickerModel(i10n?.memberTypeAnon ?? 'Anonymous', 'anon')
    ];
  }

  List<StringPickerModel> _getSafeMemberTypes(AppLocalizations? i10n) {
    return <StringPickerModel>[
      StringPickerModel(i10n?.memberTypeSysop ?? 'SysopX', 'sysop'),
      StringPickerModel(i10n?.memberTypeAdmin ?? 'Administrators', 'admin'),
      StringPickerModel(i10n?.memberTypeMember ?? 'Members', 'member')
    ];
  }

  Future savePressed() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });

      Gffft gffft = Gffft(
          name: editName,
          allowMembers: editAllowMembers,
          boardEnabled: editBoardEnabled,
          boardWhoCanPost: editBoardWhoCanPost?.code,
          boardWhoCanView: editBoardWhoCanView?.code,
          description: editDescription,
          enabled: editEnabled,
          enableAltHandles: editEnableAltHandles,
          galleryEnabled: editGalleryEnabled,
          galleryWhoCanPost: editGalleryWhoCanPost?.code,
          galleryWhoCanView: editBoardWhoCanView?.code,
          intro: editIntro,
          pagesEnabled: editPagesEnabled,
          pagesWhoCanEdit: editPagesWhoCanEdit?.code,
          pagesWhoCanView: editPagesWhoCanView?.code,
          requireApproval: editRequireApproval);
      gffftApi.save(gffft).then((value) => Navigator.pop(context)).onError((error, stackTrace) => {
            setState(() {
              print(error);
              print(stackTrace);
              errorLoading = error.toString();
              isLoading = false;
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? i10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    List<StringPickerModel> memberTypes = _getMemberTypes(i10n);
    List<StringPickerModel> safeMemberTypes = _getSafeMemberTypes(i10n);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "${i10n!.host} - ${editName}",
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
        child: ModalProgressHUD(
          inAsyncCall: isLoading && initialLoad,
          child: initialLoad
              ? Container()
              : Form(
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
                            initialValue: editName,
                            validator: (value) {
                              if (value == null || value.isEmpty) return i10n.validateFieldIsRequired(i10n.editName);
                            },
                            onChanged: (value) => setState(() {
                              editName = value;
                            }),
                            contentPadding: const EdgeInsets.all(8),
                            contentOnNewLine: true,
                            maxLength: 128,
                            showCounter: true,
                          ),
                          CardSettingsText(
                            label: i10n.editDescription,
                            initialValue: editDescription,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return i10n.validateFieldIsRequired(i10n.editDescription);
                            },
                            onChanged: (value) => setState(() {
                              editDescription = value;
                            }),
                            contentPadding: const EdgeInsets.all(8),
                            contentOnNewLine: true,
                            hintText: i10n.editDescriptionHint,
                            maxLength: 256,
                            showCounter: true,
                          ),
                          CardSettingsCheckboxPicker<String>(
                            label: i10n.editTags,
                            initialItems: editTags,
                            items: allTags,
                            onChanged: (value) => editTags = value,
                          ),
                          CardSettingsParagraph(
                            label: i10n.editIntro,
                            initialValue: editIntro,
                            onChanged: (value) => editIntro = value,
                            contentOnNewLine: true,
                            hintText: i10n.editIntroHint,
                          ),
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
                              onChanged: (value) => setState(() {
                                editAllowMembers = value;
                              }),
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                            ),
                            CardSettingsSwitch(
                              label: i10n.editRequireApproval,
                              initialValue: editRequireApproval,
                              onChanged: (value) => setState(() {
                                editRequireApproval = value;
                              }),
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                            ),
                            CardSettingsInstructions(text: i10n.editRequireApprovalHint),
                            CardSettingsSwitch(
                              label: i10n.editEnableAltHandles,
                              initialValue: editEnableAltHandles,
                              onChanged: (value) => setState(() {
                                editEnableAltHandles = value;
                              }),
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
                              onChanged: (value) => setState(() {
                                editPagesEnabled = value;
                              }),
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                                label: i10n.editPagesWhoCanView,
                                initialItem: editPagesWhoCanView ?? memberTypes[0],
                                onChanged: (value) => setState(() {
                                      editPagesWhoCanView = value;
                                    }),
                                items: memberTypes),
                            CardSettingsListPicker<StringPickerModel>(
                                label: i10n.editPagesWhoCanEdit,
                                initialItem: editPagesWhoCanEdit ?? safeMemberTypes[0],
                                onChanged: (value) => setState(() {
                                      editPagesWhoCanEdit = value;
                                    }),
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
                              onChanged: (value) => setState(() {
                                editBoardEnabled = value;
                              }),
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                                label: i10n.editBoardWhoCanView,
                                initialItem: editBoardWhoCanView ?? memberTypes[0],
                                onChanged: (value) => setState(() {
                                      editBoardWhoCanView = value;
                                    }),
                                items: memberTypes),
                            CardSettingsListPicker<StringPickerModel>(
                                label: i10n.editBoardWhoCanPost,
                                initialItem: editBoardWhoCanPost ?? safeMemberTypes[0],
                                onChanged: (value) => setState(() {
                                      editBoardWhoCanPost = value;
                                    }),
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
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                              onChanged: (value) => setState(() {
                                editGalleryEnabled = value;
                              }),
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                              label: i10n.editBoardWhoCanView,
                              initialItem: editGalleryWhoCanView ?? memberTypes[1],
                              items: memberTypes,
                              onChanged: (value) => setState(() {
                                editGalleryWhoCanView = value;
                              }),
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                              label: i10n.editBoardWhoCanPost,
                              initialItem: editGalleryWhoCanPost ?? safeMemberTypes[0],
                              items: safeMemberTypes,
                              onSaved: (value) => editGalleryWhoCanPost = value,
                              onChanged: (value) => setState(() {
                                editGalleryWhoCanPost = value;
                              }),
                            )
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: i10n.editActions,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: i10n.editEnabled,
                              initialValue: editEnabled,
                              onSaved: (value) => editEnabled = value ?? false,
                              trueLabel: i10n.yes,
                              falseLabel: i10n.no,
                              onChanged: (value) => setState(() {
                                editEnabled = value;
                              }),
                            ),
                            CardSettingsButton(
                                backgroundColor: theme.backgroundColor,
                                label: i10n.editSave,
                                showMaterialonIOS: true,
                                onPressed: savePressed),
                          ])
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
