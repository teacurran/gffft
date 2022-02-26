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

  /// `add a post`
  String get boardViewActionTooltip {
    return Intl.message(
      'add a post',
      name: 'boardViewActionTooltip',
      desc: '',
      args: [],
    );
  }

  /// `post`
  String get boardCreatePostTitle {
    return Intl.message(
      'post',
      name: 'boardCreatePostTitle',
      desc: '',
      args: [],
    );
  }

  /// `body`
  String get boardCreatePostBody {
    return Intl.message(
      'body',
      name: 'boardCreatePostBody',
      desc: '',
      args: [],
    );
  }

  /// `reply`
  String get boardReplyToThread {
    return Intl.message(
      'reply',
      name: 'boardReplyToThread',
      desc: '',
      args: [],
    );
  }

  /// `subject`
  String get boardCreatePostSubject {
    return Intl.message(
      'subject',
      name: 'boardCreatePostSubject',
      desc: '',
      args: [],
    );
  }

  /// `profile`
  String get boardThreadAuthorVisit {
    return Intl.message(
      'profile',
      name: 'boardThreadAuthorVisit',
      desc: '',
      args: [],
    );
  }

  /// `report`
  String get boardThreadAuthorReport {
    return Intl.message(
      'report',
      name: 'boardThreadAuthorReport',
      desc: '',
      args: [],
    );
  }

  /// `post!`
  String get boardCreatePostPost {
    return Intl.message(
      'post!',
      name: 'boardCreatePostPost',
      desc: '',
      args: [],
    );
  }

  /// `bookmarks`
  String get bookmarks {
    return Intl.message(
      'bookmarks',
      name: 'bookmarks',
      desc: '',
      args: [],
    );
  }

  /// `connect`
  String get connect {
    return Intl.message(
      'connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Change Username`
  String get changeUsername {
    return Intl.message(
      'Change Username',
      name: 'changeUsername',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get editActions {
    return Intl.message(
      'Actions',
      name: 'editActions',
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

  /// `post`
  String get galleryPostTitle {
    return Intl.message(
      'post',
      name: 'galleryPostTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description, if you feel like it...`
  String get galleryPostCaption {
    return Intl.message(
      'Description, if you feel like it...',
      name: 'galleryPostCaption',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get editIntro {
    return Intl.message(
      'Introduction',
      name: 'editIntro',
      desc: '',
      args: [],
    );
  }

  /// `Longer introduction to this gffft`
  String get editIntroHint {
    return Intl.message(
      'Longer introduction to this gffft',
      name: 'editIntroHint',
      desc: '',
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

  /// `Calendar`
  String get editCalendar {
    return Intl.message(
      'Calendar',
      name: 'editCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Notebook`
  String get editNotebook {
    return Intl.message(
      'Notebook',
      name: 'editNotebook',
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

  /// `People will have to apply for access to your gffft.`
  String get editRequireApprovalHint {
    return Intl.message(
      'People will have to apply for access to your gffft.',
      name: 'editRequireApprovalHint',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get editSave {
    return Intl.message(
      'Save',
      name: 'editSave',
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

  /// `Add a #tag`
  String get editTagsInputHint {
    return Intl.message(
      'Add a #tag',
      name: 'editTagsInputHint',
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

  /// `This is your gffft. A space where you can create and share content with others.  You can keep your gffft private, make it public, or invite others to join you. To get started, edit this text or add a feature below.`
  String get gffftIntro {
    return Intl.message(
      'This is your gffft. A space where you can create and share content with others.  You can keep your gffft private, make it public, or invite others to join you. To get started, edit this text or add a feature below.',
      name: 'gffftIntro',
      desc: '',
      args: [],
    );
  }

  /// `edit`
  String get gffftEdit {
    return Intl.message(
      'edit',
      name: 'gffftEdit',
      desc: '',
      args: [],
    );
  }

  /// `stop editing`
  String get gffftEditStop {
    return Intl.message(
      'stop editing',
      name: 'gffftEditStop',
      desc: '',
      args: [],
    );
  }

  /// `links`
  String get gffftHomeLinkSet {
    return Intl.message(
      'links',
      name: 'gffftHomeLinkSet',
      desc: '',
      args: [],
    );
  }

  /// `links:`
  String get gffftHomeLinkSetLinks {
    return Intl.message(
      'links:',
      name: 'gffftHomeLinkSetLinks',
      desc: '',
      args: [],
    );
  }

  /// `join this gffft`
  String get gffftJoin {
    return Intl.message(
      'join this gffft',
      name: 'gffftJoin',
      desc: '',
      args: [],
    );
  }

  /// `rules`
  String get gffftJoinRules {
    return Intl.message(
      'rules',
      name: 'gffftJoinRules',
      desc: '',
      args: [],
    );
  }

  /// `handle`
  String get gffftJoinHandle {
    return Intl.message(
      'handle',
      name: 'gffftJoinHandle',
      desc: '',
      args: [],
    );
  }

  /// `What would you like to be known as on this gffft?`
  String get gffftJoinHandleHint {
    return Intl.message(
      'What would you like to be known as on this gffft?',
      name: 'gffftJoinHandleHint',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, that handle is already taken on this gffft.`
  String get gffftJoinHandleError {
    return Intl.message(
      'Sorry, that handle is already taken on this gffft.',
      name: 'gffftJoinHandleError',
      desc: '',
      args: [],
    );
  }

  /// `join!`
  String get gffftJoinButton {
    return Intl.message(
      'join!',
      name: 'gffftJoinButton',
      desc: '',
      args: [],
    );
  }

  /// `your membership`
  String get gffftMembershipTitle {
    return Intl.message(
      'your membership',
      name: 'gffftMembershipTitle',
      desc: '',
      args: [],
    );
  }

  /// `save!`
  String get gffftMembershipSaveButton {
    return Intl.message(
      'save!',
      name: 'gffftMembershipSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `save and exit`
  String get gffftSettingsSave {
    return Intl.message(
      'save and exit',
      name: 'gffftSettingsSave',
      desc: '',
      args: [],
    );
  }

  /// `settings`
  String get gffftSettingsHead {
    return Intl.message(
      'settings',
      name: 'gffftSettingsHead',
      desc: '',
      args: [],
    );
  }

  /// `general`
  String get gffftSettingsGeneralHead {
    return Intl.message(
      'general',
      name: 'gffftSettingsGeneralHead',
      desc: '',
      args: [],
    );
  }

  /// `Show in search`
  String get gffftSettingsEnabled {
    return Intl.message(
      'Show in search',
      name: 'gffftSettingsEnabled',
      desc: '',
      args: [],
    );
  }

  /// `This will enable your gffft to be searched.  To share with just your friends, use a fruit-code instead.`
  String get gffftSettingsEnabledHint {
    return Intl.message(
      'This will enable your gffft to be searched.  To share with just your friends, use a fruit-code instead.',
      name: 'gffftSettingsEnabledHint',
      desc: '',
      args: [],
    );
  }

  /// `Enable membership`
  String get gffftSettingsEnableMembership {
    return Intl.message(
      'Enable membership',
      name: 'gffftSettingsEnableMembership',
      desc: '',
      args: [],
    );
  }

  /// `This allows other people to join your gffft and participate in message boards, galleries, or other features.  Be careful before enabling membership.`
  String get gffftSettingsEnableMembershipHint {
    return Intl.message(
      'This allows other people to join your gffft and participate in message boards, galleries, or other features.  Be careful before enabling membership.',
      name: 'gffftSettingsEnableMembershipHint',
      desc: '',
      args: [],
    );
  }

  /// `Enable Message Board`
  String get gffftSettingsEnableMessageBoard {
    return Intl.message(
      'Enable Message Board',
      name: 'gffftSettingsEnableMessageBoard',
      desc: '',
      args: [],
    );
  }

  /// `A message board enables you or your guests to post text based threaded messages.`
  String get gffftSettingsEnableMessageBoardHint {
    return Intl.message(
      'A message board enables you or your guests to post text based threaded messages.',
      name: 'gffftSettingsEnableMessageBoardHint',
      desc: '',
      args: [],
    );
  }

  /// `Enable calendar`
  String get gffftSettingsEnableCalendar {
    return Intl.message(
      'Enable calendar',
      name: 'gffftSettingsEnableCalendar',
      desc: '',
      args: [],
    );
  }

  /// `A shared calendar that is designed for shared events in the future as well as memories in the past. This is not your office calendar.`
  String get gffftSettingsEnableCalendarHint {
    return Intl.message(
      'A shared calendar that is designed for shared events in the future as well as memories in the past. This is not your office calendar.',
      name: 'gffftSettingsEnableCalendarHint',
      desc: '',
      args: [],
    );
  }

  /// `Who can view:`
  String get gffftSettingsBoardWhoCanView {
    return Intl.message(
      'Who can view:',
      name: 'gffftSettingsBoardWhoCanView',
      desc: '',
      args: [],
    );
  }

  /// `Who can post:`
  String get gffftSettingsBoardWhoCanPost {
    return Intl.message(
      'Who can post:',
      name: 'gffftSettingsBoardWhoCanPost',
      desc: '',
      args: [],
    );
  }

  /// `Enable gallery`
  String get gffftSettingsGalleryEnable {
    return Intl.message(
      'Enable gallery',
      name: 'gffftSettingsGalleryEnable',
      desc: '',
      args: [],
    );
  }

  /// `A gallery allows you or your gffft's members to post photos and videos. Configure to be viewed as a stream or contact-sheet style.`
  String get gffftSettingsGalleryEnableHint {
    return Intl.message(
      'A gallery allows you or your gffft\'s members to post photos and videos. Configure to be viewed as a stream or contact-sheet style.',
      name: 'gffftSettingsGalleryEnableHint',
      desc: '',
      args: [],
    );
  }

  /// `Save links for yourself or others`
  String get gffftSettingsLinkSetEnableHint {
    return Intl.message(
      'Save links for yourself or others',
      name: 'gffftSettingsLinkSetEnableHint',
      desc: '',
      args: [],
    );
  }

  /// `Enable links`
  String get gffftSettingsLinkSetEnable {
    return Intl.message(
      'Enable links',
      name: 'gffftSettingsLinkSetEnable',
      desc: '',
      args: [],
    );
  }

  /// `Enable notebook`
  String get gffftSettingsNotebookEnable {
    return Intl.message(
      'Enable notebook',
      name: 'gffftSettingsNotebookEnable',
      desc: '',
      args: [],
    );
  }

  /// `Notebooks can be used to create pages to share. Notebooks can be configured to display content inline like a blog, or as a list.`
  String get gffftSettingsNotebookEnableHint {
    return Intl.message(
      'Notebooks can be used to create pages to share. Notebooks can be configured to display content inline like a blog, or as a list.',
      name: 'gffftSettingsNotebookEnableHint',
      desc: '',
      args: [],
    );
  }

  /// `Who can view:`
  String get gffftSettingsNotebookWhoCanView {
    return Intl.message(
      'Who can view:',
      name: 'gffftSettingsNotebookWhoCanView',
      desc: '',
      args: [],
    );
  }

  /// `Who can edit:`
  String get gffftSettingsNotebookWhoCanEdit {
    return Intl.message(
      'Who can edit:',
      name: 'gffftSettingsNotebookWhoCanEdit',
      desc: '',
      args: [],
    );
  }

  /// `fruit code`
  String get gffftSettingsFruitCode {
    return Intl.message(
      'fruit code',
      name: 'gffftSettingsFruitCode',
      desc: '',
      args: [],
    );
  }

  /// `use fruit codes to share your gffft with others`
  String get gffftSettingsFruitCodeHint {
    return Intl.message(
      'use fruit codes to share your gffft with others',
      name: 'gffftSettingsFruitCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `¡gffft!`
  String get gffftSettingsFruitCodeShare {
    return Intl.message(
      '¡gffft!',
      name: 'gffftSettingsFruitCodeShare',
      desc: '',
      args: [],
    );
  }

  /// `copy to clipboard`
  String get gffftSettingsFruitCodeCopy {
    return Intl.message(
      'copy to clipboard',
      name: 'gffftSettingsFruitCodeCopy',
      desc: '',
      args: [],
    );
  }

  /// `fruit code copied to the clipboard`
  String get gffftSettingsFruitCodeCopied {
    return Intl.message(
      'fruit code copied to the clipboard',
      name: 'gffftSettingsFruitCodeCopied',
      desc: '',
      args: [],
    );
  }

  /// `blog`
  String get gffftHomeBlog {
    return Intl.message(
      'blog',
      name: 'gffftHomeBlog',
      desc: '',
      args: [],
    );
  }

  /// `membership`
  String get gffftHomeMembership {
    return Intl.message(
      'membership',
      name: 'gffftHomeMembership',
      desc: '',
      args: [],
    );
  }

  /// `since {date}`
  String gffftHomeMemberSince(String date) {
    return Intl.message(
      'since $date',
      name: 'gffftHomeMemberSince',
      desc: '\'since 2021-01-12\' formatted in users date format',
      args: [date],
    );
  }

  /// `show fruit code`
  String get gffftSettingsFruitCodeEnable {
    return Intl.message(
      'show fruit code',
      name: 'gffftSettingsFruitCodeEnable',
      desc: '',
      args: [],
    );
  }

  /// `not a member`
  String get gffftHomeNotMember {
    return Intl.message(
      'not a member',
      name: 'gffftHomeNotMember',
      desc: '',
      args: [],
    );
  }

  /// `join`
  String get gffftHomeJoin {
    return Intl.message(
      'join',
      name: 'gffftHomeJoin',
      desc: '',
      args: [],
    );
  }

  /// `quit`
  String get gffftHomeQuit {
    return Intl.message(
      'quit',
      name: 'gffftHomeQuit',
      desc: '',
      args: [],
    );
  }

  /// `bookmark`
  String get gffftHomeBookmark {
    return Intl.message(
      'bookmark',
      name: 'gffftHomeBookmark',
      desc: '',
      args: [],
    );
  }

  /// `un-bookmark`
  String get gffftHomeUnBookmark {
    return Intl.message(
      'un-bookmark',
      name: 'gffftHomeUnBookmark',
      desc: '',
      args: [],
    );
  }

  /// `board`
  String get gffftHomeBoard {
    return Intl.message(
      'board',
      name: 'gffftHomeBoard',
      desc: '',
      args: [],
    );
  }

  /// `gallery`
  String get gffftHomeGallery {
    return Intl.message(
      'gallery',
      name: 'gffftHomeGallery',
      desc: '',
      args: [],
    );
  }

  /// `photos:`
  String get gffftHomeGalleryPhotos {
    return Intl.message(
      'photos:',
      name: 'gffftHomeGalleryPhotos',
      desc: '',
      args: [],
    );
  }

  /// `videos:`
  String get gffftHomeGalleryVideos {
    return Intl.message(
      'videos:',
      name: 'gffftHomeGalleryVideos',
      desc: '',
      args: [],
    );
  }

  /// `notebook`
  String get gffftHomePages {
    return Intl.message(
      'notebook',
      name: 'gffftHomePages',
      desc: '',
      args: [],
    );
  }

  /// `calendar`
  String get gffftHomeCalendar {
    return Intl.message(
      'calendar',
      name: 'gffftHomeCalendar',
      desc: '',
      args: [],
    );
  }

  /// `name or fruit-code`
  String get gffftListSearchHint {
    return Intl.message(
      'name or fruit-code',
      name: 'gffftListSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `account since {date}`
  String homeAccountSince(String date) {
    return Intl.message(
      'account since $date',
      name: 'homeAccountSince',
      desc: '\'since 2021-01-12\' formatted in users date format',
      args: [date],
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

  /// `Add a Link`
  String get linkSetViewActionTooltip {
    return Intl.message(
      'Add a Link',
      name: 'linkSetViewActionTooltip',
      desc: '',
      args: [],
    );
  }

  /// `https://`
  String get linkSetPostUrl {
    return Intl.message(
      'https://',
      name: 'linkSetPostUrl',
      desc: '',
      args: [],
    );
  }

  /// `Description (optional)`
  String get linkSetPostDescription {
    return Intl.message(
      'Description (optional)',
      name: 'linkSetPostDescription',
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

  /// `logged in`
  String get loggedIn {
    return Intl.message(
      'logged in',
      name: 'loggedIn',
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

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `show less`
  String get showLess {
    return Intl.message(
      'show less',
      name: 'showLess',
      desc: '',
      args: [],
    );
  }

  /// `show more`
  String get showMore {
    return Intl.message(
      'show more',
      name: 'showMore',
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
