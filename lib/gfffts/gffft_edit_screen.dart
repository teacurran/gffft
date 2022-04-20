import 'package:card_settings/card_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:gffft/components/card_settings_tag.dart';
import 'package:gffft/style/app_theme.dart';
import 'package:gffft/ui/string_picker_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'gffft_api.dart';
import 'models/gffft_save.dart';

final getIt = GetIt.instance;

class GffftEditScreen extends StatefulWidget {
  const GffftEditScreen({Key? key, required this.uid, required this.gid}) : super(key: key);

  final String uid;
  final String gid;

  static const String id = 'Gffft Edit';

  @override
  _GffftEditScreenState createState() => _GffftEditScreenState();
}

class _GffftEditScreenState extends State<GffftEditScreen> {
  GffftApi gffftApi = getIt<GffftApi>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool initialLoad = true;
  bool isLoading = false;
  String? errorLoading;

  String? uid;
  String? gid;
  String? editName;
  String? editDescription;
  String? editIntro;
  List<String>? editTags = <String>[];
  bool editEnabled = false;

  bool editAllowMembers = false;
  bool editRequireApproval = false;
  bool editEnableAltHandles = false;

  bool editBoardEnabled = false;
  bool editCalendarEnabled = false;
  bool editGalleryEnabled = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    gffftApi
        .getGffft(widget.uid, widget.gid)
        .then((gffft) => {
              setState(() {
                if (kDebugMode) print("got gffft ${gffft.toJson()}");
                uid = gffft.uid;
                gid = gffft.gid;
                editName = gffft.name;
                editDescription = gffft.description;
                editIntro = gffft.intro;
                editEnableAltHandles = gffft.enableAltHandles;
                editAllowMembers = gffft.allowMembers;
                editRequireApproval = gffft.requireApproval;
                editEnabled = gffft.enabled;
                editTags = gffft.tags;

                initialLoad = false;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              if (kDebugMode) {print(error)}
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

      GffftSave gffft = GffftSave(
          uid: widget.uid,
          gid: widget.gid,
          name: editName,
          requireApproval: editRequireApproval,
          intro: editIntro,
          allowMembers: editAllowMembers,
          description: editDescription,
          enabled: editEnabled,
          enableAltHandles: editEnableAltHandles,
          boardEnabled: editBoardEnabled,
          calendarEnabled: editCalendarEnabled,
          galleryEnabled: editGalleryEnabled,
          tags: editTags);

      gffftApi.save(gffft).then((value) => Navigator.pop(context)).onError((error, stackTrace) => {
            setState(() {
              if (kDebugMode) print(error);
              if (kDebugMode) print(stackTrace);
              errorLoading = error.toString();
              isLoading = false;
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? l10n = AppLocalizations.of(context);
    final theme = context.appTheme.materialTheme;

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
                          color: theme.primaryColor,
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
                              if (value == null || value.isEmpty) {
                                return l10n.validateFieldIsRequired(l10n.editDescription);
                              }
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
                            color: theme.primaryColor,
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
                            label: l10n.editBoard,
                            color: theme.primaryColor,
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
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editGallery,
                            color: theme.primaryColor,
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
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editCalendar,
                            color: theme.primaryColor,
                          ),
                          children: <CardSettingsWidget>[
                            CardSettingsSwitch(
                              label: l10n.editEnabled,
                              initialValue: editCalendarEnabled,
                              trueLabel: l10n.yes,
                              falseLabel: l10n.no,
                              onChanged: (value) => setState(() {
                                editCalendarEnabled = value;
                              }),
                            ),
                          ]),
                      CardSettingsSection(
                          header: CardSettingsHeader(
                            label: l10n.editActions,
                            color: theme.primaryColor,
                          ),
                          children: [
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
