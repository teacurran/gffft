import 'dart:convert';

import 'package:gffft/boards/models/board.dart';

import '../api_base.dart';
import 'models/post.dart';

class BoardApi extends ApiBase {
  save(Board board) {}

  Future<Board> getDefaultBoard() async {
    final response = await getAuthenticated("boards/default");
    return Board.fromJson(response);
  }

  Future<void> createPost(Post p) async {
    print("creating post: " + jsonEncode(p));
    return post("boards/createPost", jsonEncode(p));
  }
}
