import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gffft/boards/models/thread_result.dart';
import 'package:gffft/gfffts/models/gffft.dart';
import 'package:gffft/gfffts/models/gffft_patch_save.dart';

import '../api_base.dart';
import 'models/gffft_create.dart';
import 'models/gffft_membership_post.dart';
import 'models/gffft_result.dart';
import 'models/gffft_save.dart';

class GffftApi extends ApiBase {
  Future<void> save(GffftSave gffft) async {
    return put("gfffts", jsonEncode(gffft));
  }

  Future<void> savePartial(GffftPatchSave gffft) async {
    if (kDebugMode) print("sending patch for gffft: ${gffft.toJson()}");
    return patch("gfffts", jsonEncode(gffft.toJson()));
  }

  Future<GffftResult> getGfffts(String? offset, int? max, String? q) async {
    var params = <String, String>{};
    if (offset != null) {
      params['offset'] = offset;
    }
    if (max != null) {
      params['max'] = max.toString();
    }
    if (q != null && q.isNotEmpty) {
      params['q'] = q;
    }
    final response = await get("gfffts", queryParams: params);

    return GffftResult.fromJson(response);
  }

  Future<Gffft> create(GffftCreate gffft) async {
    final response = await post("gfffts", jsonEncode(gffft));
    return Gffft.fromJson(response);
  }

  Future<Gffft> getGffft(String uid, String gid) async {
    final response = await getAuthenticated("users/$uid/gfffts/$gid");
    return Gffft.fromJson(response);
  }

  Future<void> joinGffft(String uid, String gid, String handle) async {
    var membershipPost = GffftMembershipPost(uid: uid, gid: gid, handle: handle);
    await post("users/me/gfffts/membership", jsonEncode(membershipPost));
  }

  Future<void> quitGffft(String uid, String gid) async {
    var membershipPost = GffftMembershipPost(uid: uid, gid: gid);
    await delete("users/me/gfffts/membership", jsonEncode(membershipPost));
  }

  Future<ThreadResult> getBoardThreads(String uid, String gid, String bid, String? offset, int? pageSize) async {
    final response = await getAuthenticated("users/$uid/gfffts/$gid/boards/$bid/threads");
    return ThreadResult.fromJson(response);
  }
}
