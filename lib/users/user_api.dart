import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:gffft/boards/models/thread_post_result.dart';
import 'package:gffft/boards/models/thread_result.dart';
import 'package:gffft/galleries/models/gallery.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/gfffts/models/gffft_membership_post.dart';
import 'package:gffft/users/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_base.dart';
import '../galleries/models/gallery_item.dart';
import '../link_sets/models/link_set.dart';
import 'models/bookmark_result.dart';

class UserApi extends ApiBase {
  save(User user) {}

  Future<User?> me() async {
    fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
    final fbUser = await auth.authStateChanges().first;
    if (fbUser == null) {
      return null;
    }
    await FirebaseAnalytics.instance.setUserId(id: fbUser.uid);

    final response = await getAuthenticated("users/me");

    return User.fromJson(response);
  }

  Future<User> changeUsername() async {
    final response = await postAuthenticated("users/me/change-username");

    return User.fromJson(response);
  }

  Future<Gffft> getGffft(String uid, String gid) async {
    final response = await get("users/$uid/gfffts/$gid");
    return Gffft.fromJson(response);
  }

  Future<Gffft?> getGffftIfLoggedIn(String uid, String gid) async {
    try {
      final response = await get("users/$uid/gfffts/$gid");
      return Gffft.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<ThreadResult> getBoardThreads(String uid, String gid, String bid, String? offset, int? pageSize) async {
    final response = await get("users/$uid/gfffts/$gid/boards/$bid/threads");
    return ThreadResult.fromJson(response);
  }

  Future<ThreadPostResult> getThread(
      String uid, String gid, String bid, String tid, String? offset, int? pageSize) async {
    final response = await get("users/$uid/gfffts/$gid/boards/$bid/threads/$tid");
    return ThreadPostResult.fromJson(response);
  }

  Future<BookmarkResult> getBookmarks(String? offset, int? max, String? searchTerm) async {
    fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
    final fbUser = await auth.authStateChanges().first;
    if (fbUser != null) {
      final response = await getAuthenticated("users/me/bookmarks");
      return BookmarkResult.fromJson(response);
    }
    final bookmarks = getBookmarksFromLocal();
    return bookmarks;
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

  Future<Gallery> getGallery(String uid, String gid, String mid, String? offset, int? pageSize) async {
    final response = await get("users/$uid/gfffts/$gid/galleries/$mid");
    return Gallery.fromJson(response);
  }

  Future<GalleryItem> getGalleryItem(String uid, String gid, String mid, String iid) async {
    final response = await get("users/$uid/gfffts/$gid/galleries/$mid/i/$iid");
    return GalleryItem.fromJson(response);
  }

  Future<LinkSet> getLinkSet(String uid, String gid, String lid, String? offset, int? pageSize) async {
    final response = await get("users/$uid/gfffts/$gid/links/$lid");
    return LinkSet.fromJson(response);
  }

  Future<BookmarkResult> getBookmarksFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkString = prefs.getString("bookmarks");
    if (bookmarkString != null) {
      return Future.value(BookmarkResult.fromJson(jsonDecode(bookmarkString)));
    }
    return Future.value(BookmarkResult(count: 0, items: []));
  }
}
