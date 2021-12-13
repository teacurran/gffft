import 'package:gffft/user/user.dart';

import '../api_base.dart';

class UserApi extends ApiBase {
  save(User user) {}

  Future<User> me() async {
    final response = await get("users/me");
    return User.fromJson(response);
  }
}
