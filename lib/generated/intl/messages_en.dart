// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(date) => "since ${date}";

  static String m1(field) => "${field} is required";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "boardCreatePostBody": MessageLookupByLibrary.simpleMessage("body"),
        "boardCreatePostPost": MessageLookupByLibrary.simpleMessage("post!"),
        "boardCreatePostSubject":
            MessageLookupByLibrary.simpleMessage("subject"),
        "boardCreatePostTitle":
            MessageLookupByLibrary.simpleMessage("create a post"),
        "boardReplyToThread": MessageLookupByLibrary.simpleMessage("reply"),
        "boardViewActionTooltip":
            MessageLookupByLibrary.simpleMessage("add a post"),
        "bookmarks": MessageLookupByLibrary.simpleMessage("bookmarks"),
        "changeUsername":
            MessageLookupByLibrary.simpleMessage("Change Username"),
        "connect": MessageLookupByLibrary.simpleMessage("connect"),
        "editActions": MessageLookupByLibrary.simpleMessage("Actions"),
        "editAllowMembers":
            MessageLookupByLibrary.simpleMessage("Allow Members?"),
        "editBoard": MessageLookupByLibrary.simpleMessage("Board"),
        "editBoardWhoCanPost":
            MessageLookupByLibrary.simpleMessage("Who can post?"),
        "editBoardWhoCanView":
            MessageLookupByLibrary.simpleMessage("Who can view?"),
        "editBoards": MessageLookupByLibrary.simpleMessage("Boards"),
        "editCalendar": MessageLookupByLibrary.simpleMessage("Calendar"),
        "editDescription": MessageLookupByLibrary.simpleMessage("Description"),
        "editDescriptionHint": MessageLookupByLibrary.simpleMessage(
            "A short description of your gffft that will show up in search results"),
        "editEnable": MessageLookupByLibrary.simpleMessage("Enable"),
        "editEnableAltHandles":
            MessageLookupByLibrary.simpleMessage("Enable alternate handles"),
        "editEnableAltHandlesHint": MessageLookupByLibrary.simpleMessage(
            "Allows members of your gffft to choose usernames"),
        "editEnableMembership":
            MessageLookupByLibrary.simpleMessage("Enable membership"),
        "editEnabled": MessageLookupByLibrary.simpleMessage("Enabled"),
        "editGalleries": MessageLookupByLibrary.simpleMessage("Galleries"),
        "editGallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "editIntro": MessageLookupByLibrary.simpleMessage("Introduction"),
        "editIntroHint": MessageLookupByLibrary.simpleMessage(
            "Longer introduction to this gffft"),
        "editMembership": MessageLookupByLibrary.simpleMessage("Membership"),
        "editName": MessageLookupByLibrary.simpleMessage("Name"),
        "editNotebook": MessageLookupByLibrary.simpleMessage("Notebook"),
        "editRequireApproval":
            MessageLookupByLibrary.simpleMessage("Require Approval?"),
        "editRequireApprovalHint": MessageLookupByLibrary.simpleMessage(
            "People will have to apply for access to your gffft."),
        "editSave": MessageLookupByLibrary.simpleMessage("Save"),
        "editTags": MessageLookupByLibrary.simpleMessage("Tags"),
        "editTagsHint": MessageLookupByLibrary.simpleMessage(
            "Tags allow people to find your gffft when searching"),
        "editTagsInputHint": MessageLookupByLibrary.simpleMessage("Add a #tag"),
        "editYourGffftInfo":
            MessageLookupByLibrary.simpleMessage("Your Gffft Info"),
        "errorLoading": MessageLookupByLibrary.simpleMessage("Error Loading"),
        "flag": MessageLookupByLibrary.simpleMessage("Flag"),
        "gffftHomeBlog": MessageLookupByLibrary.simpleMessage("blog"),
        "gffftHomeBoard": MessageLookupByLibrary.simpleMessage("board"),
        "gffftHomeBookmark": MessageLookupByLibrary.simpleMessage("bookmark"),
        "gffftHomeCalendar": MessageLookupByLibrary.simpleMessage("calendar"),
        "gffftHomeJoin": MessageLookupByLibrary.simpleMessage("join"),
        "gffftHomeMedia": MessageLookupByLibrary.simpleMessage("media"),
        "gffftHomeMemberSince": m0,
        "gffftHomeMembership":
            MessageLookupByLibrary.simpleMessage("membership"),
        "gffftHomeNotMember":
            MessageLookupByLibrary.simpleMessage("not a member"),
        "gffftHomePages": MessageLookupByLibrary.simpleMessage("pages"),
        "gffftHomeQuit": MessageLookupByLibrary.simpleMessage("quit"),
        "gffftHomeUnBookmark":
            MessageLookupByLibrary.simpleMessage("un-bookmark"),
        "gffftListSearchHint":
            MessageLookupByLibrary.simpleMessage("name or #tag"),
        "host": MessageLookupByLibrary.simpleMessage("Host"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "me": MessageLookupByLibrary.simpleMessage("me"),
        "memberTypeAdmin":
            MessageLookupByLibrary.simpleMessage("Administrator"),
        "memberTypeAnon": MessageLookupByLibrary.simpleMessage("Anonymous"),
        "memberTypeMember": MessageLookupByLibrary.simpleMessage("Member"),
        "memberTypeSysop": MessageLookupByLibrary.simpleMessage("Sysop"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "showLess": MessageLookupByLibrary.simpleMessage("show less"),
        "showMore": MessageLookupByLibrary.simpleMessage("show more"),
        "validateFieldIsRequired": m1,
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
