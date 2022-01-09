import 'package:gffft/boards/models/thread_result.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/users/user.dart';

import '../api_base.dart';

class UserApi extends ApiBase {
  save(User user) {}

  Future<User> me() async {
    final response = await getAuthenticated("users/me");

    return User.fromJson(response);
  }

  Future<Gffft> getGffft(String uid, String gid) async {
    final response = await getAuthenticated("users/${uid}/gfffts/${gid}");
    return Gffft.fromJson(response);
  }

  Future<ThreadResult> getBoardThreads(String uid, String gid, String bid, String? offset, int? pageSize) async {
    final response = await getAuthenticated("users/${uid}/gfffts/${gid}/boards/${bid}");
    return ThreadResult.fromJson(response);
  }
}
