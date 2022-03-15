import 'dart:convert';

import 'package:gffft/boards/models/board.dart';

import '../api_base.dart';
import 'models/post_submit.dart';

class BoardApi extends ApiBase {
  save(Board board) {}

  Future<Board> getDefaultBoard() async {
    final response = await getAuthenticated("boards/default");
    return Board.fromJson(response);
  }

  Future<void> createPost(PostSubmit p) async {
    return post("boards/createPost", jsonEncode(p));
  }

  Future<void> deleteItem(String uid, String gid, String bid, String tid) async {
    await delete("users/$uid/gfffts/$gid/boards/$bid/threads/$tid", null);
  }
}
