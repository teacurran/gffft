import 'dart:convert';

import 'package:gffft/boards/models/thread_result.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/gfffts/models/gffft_membership_post.dart';
import 'package:gffft/users/models/user.dart';

import '../api_base.dart';
import 'models/bookmark_result.dart';

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
    final response = await getAuthenticated("users/${uid}/gfffts/${gid}/boards/${bid}/threads");
    return ThreadResult.fromJson(response);
  }

  Future<BookmarkResult> getBookmarks(String? offset, int? max, String? searchTerm) async {
    final response = await getAuthenticated("users/me/bookmarks");
    return BookmarkResult.fromJson(response);
  }

  Future<void> bookmarkGffft(String uid, String gid) async {
    var membershipPost = GffftMembershipPost(uid: uid, gid: gid);
    print("bookmarking: " + jsonEncode(membershipPost));
    return await post("users/me/bookmarks", jsonEncode(membershipPost));
  }

  Future<void> unBookmarkGffft(String uid, String gid) async {
    var membershipPost = GffftMembershipPost(uid: uid, gid: gid);
    print("removing bookmark: " + jsonEncode(membershipPost));
    return delete("users/me/bookmarks", jsonEncode(membershipPost));
  }
}
