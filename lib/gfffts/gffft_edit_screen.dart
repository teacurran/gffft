import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/card_settings_tag.dart';
import 'package:gffft/ui/string_picker_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'gffft_api.dart';
import 'models/gffft.dart';

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
  String? editBoardWhoCanView;
  String? editBoardWhoCanPost;

  bool editGalleryEnabled = false;
  String? editGalleryWhoCanView;
  String? editGalleryWhoCanPost;

  bool editPagesEnabled = false;
  String? editPagesWhoCanView;
  String? editPagesWhoCanEdit;

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
                editEnableAltHandles = gffft.enableAltHandles;
                editAllowMembers = gffft.allowMembers;
                editRequireApproval = gffft.requireApproval;
                editEnabled = gffft.enabled;
                editTags = gffft.tags;

                editBoardEnabled = gffft.boardEnabled;
                editBoardWhoCanPost = gffft.boardWhoCanPost;
                editBoardWhoCanView = gffft.boardWhoCanView;

                editGalleryEnabled = gffft.galleryEnabled;
                editGalleryWhoCanPost = gffft.galleryWhoCanPost;
                editGalleryWhoCanView = gffft.galleryWhoCanView;

                editPagesEnabled = gffft.pagesEnabled;
                editPagesWhoCanEdit = gffft.pagesWhoCanEdit;
                editPagesWhoCanView = gffft.pagesWhoCanView;

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

  Map<String, List<StringPickerModel>> cachedMemberTypes = {};

  List<StringPickerModel> _getMemberTypes(AppLocalizations? l10n) {
    String locale = l10n?.localeName ?? 'default';
    if (!cachedMemberTypes.containsKey(locale)) {
      cachedMemberTypes[locale] = <StringPickerModel>[
        StringPickerModel(l10n?.memberTypeSysop ?? 'Sysop', 'sysop'),
        StringPickerModel(l10n?.memberTypeAdmin ?? 'Administrators', 'admin'),
        StringPickerModel(l10n?.memberTypeMember ?? 'Members', 'member'),
        StringPickerModel(l10n?.memberTypeAnon ?? 'Anonymous', 'anon')
      ];
    }
    List<StringPickerModel> defaultList = <StringPickerModel>[];
    return cachedMemberTypes[locale] ?? defaultList;
  }

  List<StringPickerModel> _getSafeMemberTypes(AppLocalizations? l10n) {
    String locale = "safe-${l10n?.localeName}";
    if (!cachedMemberTypes.containsKey(locale)) {
      cachedMemberTypes[locale] = <StringPickerModel>[
        StringPickerModel(l10n?.memberTypeSysop ?? 'Sysop', 'sysop'),
        StringPickerModel(l10n?.memberTypeAdmin ?? 'Administrators', 'admin'),
        StringPickerModel(l10n?.memberTypeMember ?? 'Members', 'member'),
      ];
    }
    List<StringPickerModel> defaultList = <StringPickerModel>[];
    return cachedMemberTypes[locale] ?? defaultList;
  }

  StringPickerModel? _selectOrFirst(List<StringPickerModel> list, String? code) {
    return list.firstWhere((element) => element.code == code, orElse: () => list.first);
  }

  Future savePressed() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });

      Gffft gffft = Gffft(
          name: editName,
          requireApproval: editRequireApproval,
          intro: editIntro,
          allowMembers: editAllowMembers,
          description: editDescription,
          enabled: editEnabled,
          enableAltHandles: editEnableAltHandles,
          boardEnabled: editBoardEnabled,
          boardWhoCanPost: editBoardWhoCanPost,
          boardWhoCanView: editBoardWhoCanView,
          galleryEnabled: editGalleryEnabled,
          galleryWhoCanPost: editGalleryWhoCanPost,
          galleryWhoCanView: editGalleryWhoCanView,
          pagesEnabled: editPagesEnabled,
          pagesWhoCanEdit: editPagesWhoCanEdit,
          pagesWhoCanView: editPagesWhoCanView,
          tags: editTags);

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
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    List<StringPickerModel> memberTypes = _getMemberTypes(l10n);
    List<StringPickerModel> safeMemberTypes = _getSafeMemberTypes(l10n);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n!.host,
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
                          label: l10n.editYourGffftInfo,
                        ),
                        children: <CardSettingsWidget>[
                          CardSettingsText(
                            label: l10n.editName,
                            initialValue: editName,
                            validator: (value) {
                              if (value == null || value.isEmpty) return l10n.validateFieldIsRequired(l10n.editName);
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
                            label: l10n.editDescription,
                            initialValue: editDescription,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return l10n.validateFieldIsRequired(l10n.editDescription);
                            },
                            onChanged: (value) => setState(() {
                              editDescription = value;
                            }),
                            contentPadding: const EdgeInsets.all(8),
                            contentOnNewLine: true,
                            hintText: l10n.editDescriptionHint,
                            maxLength: 256,
                            showCounter: true,
                          ),
                          CardSettingsTag(
                            initialItems: editTags,
                            label: l10n.editTags,
                            hintText: l10n.editTagsInputHint,
                            onChanged: (value) => setState(() {
                              editTags = value;
                            }),
                          ),
                          CardSettingsParagraph(
                            label: l10n.editIntro,
                            initialValue: editIntro,
                            onChanged: (value) => setState(() {
                              editIntro = value;
                            }),
                            contentOnNewLine: true,
                            hintText: l10n.editIntroHint,
                            maxLength: 1024,
                          ),
                        ],
                      ),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editMembership,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editAllowMembers,
                              initialValue: editAllowMembers,
                              onChanged: (value) => setState(() {
                                editAllowMembers = value;
                              }),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                            ),
                            CardSettingsSwitch(
                              label: l10n.editRequireApproval,
                              initialValue: editRequireApproval,
                              onChanged: (value) => setState(() {
                                editRequireApproval = value;
                              }),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                            ),
                            CardSettingsInstructions(text: l10n.editRequireApprovalHint),
                            CardSettingsSwitch(
                              label: l10n.editEnableAltHandles,
                              initialValue: editEnableAltHandles,
                              onChanged: (value) => setState(() {
                                editEnableAltHandles = value;
                              }),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                            ),
                            CardSettingsInstructions(text: l10n.editEnableAltHandlesHint)
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editPages,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editEnabled,
                              initialValue: editPagesEnabled,
                              onChanged: (value) => setState(() {
                                editPagesEnabled = value;
                              }),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                                label: l10n.editPagesWhoCanView,
                                initialItem: _selectOrFirst(memberTypes, editPagesWhoCanView),
                                onChanged: (value) => setState(() {
                                      editPagesWhoCanView = value.code;
                                    }),
                                items: memberTypes),
                            CardSettingsListPicker<StringPickerModel>(
                                label: l10n.editPagesWhoCanEdit,
                                initialItem: _selectOrFirst(safeMemberTypes, editPagesWhoCanEdit),
                                onChanged: (value) => setState(() {
                                      editPagesWhoCanEdit = value.code;
                                    }),
                                items: safeMemberTypes)
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editBoard,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editEnabled,
                              initialValue: editBoardEnabled,
                              onChanged: (value) => setState(() {
                                editBoardEnabled = value;
                              }),
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                                label: l10n.editBoardWhoCanView,
                                initialItem: _selectOrFirst(memberTypes, editBoardWhoCanView),
                                onChanged: (value) => setState(() {
                                      editBoardWhoCanView = value.code;
                                    }),
                                items: memberTypes),
                            CardSettingsListPicker<StringPickerModel>(
                                label: l10n.editBoardWhoCanPost,
                                initialItem: _selectOrFirst(safeMemberTypes, editBoardWhoCanPost),
                                onChanged: (value) => setState(() {
                                      editBoardWhoCanPost = value.code;
                                    }),
                                items: safeMemberTypes)
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editGallery,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editEnabled,
                              initialValue: editGalleryEnabled,
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                              onChanged: (value) => setState(() {
                                editGalleryEnabled = value;
                              }),
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                              label: l10n.editBoardWhoCanView,
                              initialItem: _selectOrFirst(memberTypes, editGalleryWhoCanView),
                              items: memberTypes,
                              onChanged: (value) => setState(() {
                                editGalleryWhoCanView = value.code;
                              }),
                            ),
                            CardSettingsListPicker<StringPickerModel>(
                              label: l10n.editBoardWhoCanPost,
                              initialItem: _selectOrFirst(safeMemberTypes, editGalleryWhoCanPost),
                              items: safeMemberTypes,
                              onChanged: (value) => setState(() {
                                editGalleryWhoCanPost = value.code;
                              }),
                            )
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editActions,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editEnabled,
                              initialValue: editEnabled,
                              onSaved: (value) => editEnabled = value ?? false,
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                              onChanged: (value) => setState(() {
                                editEnabled = value;
                              }),
                            ),
                            CardSettingsButton(
                                backgroundColor: theme.backgroundColor,
                                label: l10n.editSave,
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
