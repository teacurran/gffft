// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Connect`
  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Allow Members?`
  String get editAllowMembers {
    return Intl.message(
      'Allow Members?',
      name: 'editAllowMembers',
      desc: '',
      args: [],
    );
  }

  /// `Board`
  String get editBoard {
    return Intl.message(
      'Board',
      name: 'editBoard',
      desc: 'header for edit Boards',
      args: [],
    );
  }

  /// `Boards`
  String get editBoards {
    return Intl.message(
      'Boards',
      name: 'editBoards',
      desc: 'header for edit Boards',
      args: [],
    );
  }

  /// `Who can post?`
  String get editBoardWhoCanPost {
    return Intl.message(
      'Who can post?',
      name: 'editBoardWhoCanPost',
      desc: 'Who is allowed to post on a Gffft\'s board',
      args: [],
    );
  }

  /// `Who can view?`
  String get editBoardWhoCanView {
    return Intl.message(
      'Who can view?',
      name: 'editBoardWhoCanView',
      desc: 'Who can view a board',
      args: [],
    );
  }

  /// `Description`
  String get editDescription {
    return Intl.message(
      'Description',
      name: 'editDescription',
      desc: 'Gffft Short Description',
      args: [],
    );
  }

  /// `A short description of your gffft that will show up in search results`
  String get editDescriptionHint {
    return Intl.message(
      'A short description of your gffft that will show up in search results',
      name: 'editDescriptionHint',
      desc: 'Hint for Gffft Short Description',
      args: [],
    );
  }

  /// `Enable`
  String get editEnable {
    return Intl.message(
      'Enable',
      name: 'editEnable',
      desc: 'toggle settings enable label',
      args: [],
    );
  }

  /// `Enable alternate handles`
  String get editEnableAltHandles {
    return Intl.message(
      'Enable alternate handles',
      name: 'editEnableAltHandles',
      desc: 'Controls wether the Gffft allows alternate handles',
      args: [],
    );
  }

  /// `Allows members of your gffft to choose usernames`
  String get editEnableAltHandlesHint {
    return Intl.message(
      'Allows members of your gffft to choose usernames',
      name: 'editEnableAltHandlesHint',
      desc: 'Hint for enableing alt handles on a Gffft',
      args: [],
    );
  }

  /// `Enabled`
  String get editEnabled {
    return Intl.message(
      'Enabled',
      name: 'editEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Enable membership`
  String get editEnableMembership {
    return Intl.message(
      'Enable membership',
      name: 'editEnableMembership',
      desc: '',
      args: [],
    );
  }

  /// `Galleries`
  String get editGalleries {
    return Intl.message(
      'Galleries',
      name: 'editGalleries',
      desc: 'Header for Galleries settings',
      args: [],
    );
  }

  /// `Gallery`
  String get editGallery {
    return Intl.message(
      'Gallery',
      name: 'editGallery',
      desc: 'Header for Gallery settings',
      args: [],
    );
  }

  /// `Membership`
  String get editMembership {
    return Intl.message(
      'Membership',
      name: 'editMembership',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get editName {
    return Intl.message(
      'Name',
      name: 'editName',
      desc: 'Name of Gffft',
      args: [],
    );
  }

  /// `Pages`
  String get editPages {
    return Intl.message(
      'Pages',
      name: 'editPages',
      desc: '',
      args: [],
    );
  }

  /// `Who can edit?`
  String get editPagesWhoCanEdit {
    return Intl.message(
      'Who can edit?',
      name: 'editPagesWhoCanEdit',
      desc: '',
      args: [],
    );
  }

  /// `Who can view?`
  String get editPagesWhoCanView {
    return Intl.message(
      'Who can view?',
      name: 'editPagesWhoCanView',
      desc: '',
      args: [],
    );
  }

  /// `Require Approval?`
  String get editRequireApproval {
    return Intl.message(
      'Require Approval?',
      name: 'editRequireApproval',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get editTags {
    return Intl.message(
      'Tags',
      name: 'editTags',
      desc: 'Tags to help people find your gffft',
      args: [],
    );
  }

  /// `Tags allow people to find your gffft when searching`
  String get editTagsHint {
    return Intl.message(
      'Tags allow people to find your gffft when searching',
      name: 'editTagsHint',
      desc: '',
      args: [],
    );
  }

  /// `Your Gffft Info`
  String get editYourGffftInfo {
    return Intl.message(
      'Your Gffft Info',
      name: 'editYourGffftInfo',
      desc: 'Section header on edit screen',
      args: [],
    );
  }

  /// `Error Loading`
  String get errorLoading {
    return Intl.message(
      'Error Loading',
      name: 'errorLoading',
      desc: '',
      args: [],
    );
  }

  /// `Flag`
  String get flag {
    return Intl.message(
      'Flag',
      name: 'flag',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get host {
    return Intl.message(
      'Host',
      name: 'host',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `me`
  String get me {
    return Intl.message(
      'me',
      name: 'me',
      desc: '',
      args: [],
    );
  }

  /// `Administrator`
  String get memberTypeAdmin {
    return Intl.message(
      'Administrator',
      name: 'memberTypeAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get memberTypeAnon {
    return Intl.message(
      'Anonymous',
      name: 'memberTypeAnon',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get memberTypeMember {
    return Intl.message(
      'Member',
      name: 'memberTypeMember',
      desc: '',
      args: [],
    );
  }

  /// `Sysop`
  String get memberTypeSysop {
    return Intl.message(
      'Sysop',
      name: 'memberTypeSysop',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `{field} is required`
  String validateFieldIsRequired(Object field) {
    return Intl.message(
      '$field is required',
      name: 'validateFieldIsRequired',
      desc: '',
      args: [field],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
