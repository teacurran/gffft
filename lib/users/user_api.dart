import 'package:gffft/users/user.dart';

import '../api_base.dart';

class UserApi extends ApiBase {
  save(User user) {}

  Future<User> me() async {
    final response = await getAuthenticated("users/me");

    return User.fromJson(response);
  }
}
