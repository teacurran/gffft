import 'package:gffft/boards/board.dart';

import '../api_base.dart';

class BoardApi extends ApiBase {
  save(Board board) {}

  Future<Board> getDefaultBoard() async {
    final response = await getAuthenticated("boards/default");
    return Board.fromJson(response);
  }
}
