// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(field) => "${field} é obrigatório";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "editBoardWhoCanPost":
            MessageLookupByLibrary.simpleMessage("Quem pode postar?"),
        "editBoardWhoCanView":
            MessageLookupByLibrary.simpleMessage("Quem pode ver?"),
        "editDescription": MessageLookupByLibrary.simpleMessage("Descrição"),
        "editDescriptionHint": MessageLookupByLibrary.simpleMessage(
            "Uma breve descrição do seu gffft que aparecerá nos resultados da pesquisa"),
        "editEnableAltHandles": MessageLookupByLibrary.simpleMessage(
            "Habilitar alças alternativas"),
        "editEnableAltHandlesHint": MessageLookupByLibrary.simpleMessage(
            "Permite que membros do seu gffft escolham nomes de usuário"),
        "editEnableMembership":
            MessageLookupByLibrary.simpleMessage("Habilitar adesão"),
        "editName": MessageLookupByLibrary.simpleMessage("Nome"),
        "editTags": MessageLookupByLibrary.simpleMessage("Tag"),
        "editTagsHint": MessageLookupByLibrary.simpleMessage(
            "As tags permitem que as pessoas encontrem seu gffft ao pesquisar"),
        "editYourGffftInfo":
            MessageLookupByLibrary.simpleMessage("Suas informações Gffft"),
        "flag": MessageLookupByLibrary.simpleMessage("Bandeira"),
        "memberTypeAdmin":
            MessageLookupByLibrary.simpleMessage("Administrador"),
        "memberTypeAnon": MessageLookupByLibrary.simpleMessage("Anônimo"),
        "memberTypeMember": MessageLookupByLibrary.simpleMessage("Membro"),
        "memberTypeSysop": MessageLookupByLibrary.simpleMessage("Sysop"),
        "validateFieldIsRequired": m0
      };
}
