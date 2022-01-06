import 'dart:convert';

import 'package:gffft/boards/board.dart';

import '../api_base.dart';
import 'models/post.dart';

class BoardApi extends ApiBase {
  save(Board board) {}

  Future<Board> getDefaultBoard() async {
    final response = await getAuthenticated("boards/default");
    return Board.fromJson(response);
  }

  Future<void> createPost(Post post) async {
    return put("gfffts", jsonEncode(post));
  }
}
