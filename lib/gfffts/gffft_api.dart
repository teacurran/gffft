import 'dart:convert';

import 'package:gffft/gfffts/models/gffft.dart';

import '../api_base.dart';
import 'models/gffft_membership.dart';
import 'models/gffft_membership_post.dart';
import 'models/gffft_result.dart';
import 'models/gffft_save.dart';

class GffftApi extends ApiBase {
  Future<void> save(GffftSave gffft) async {
    return put("gfffts", jsonEncode(gffft));
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
    final response = await getAuthenticated("gfffts", queryParams: params);

    return GffftResult.fromJson(response);
  }

  Future<Gffft> getDefaultGffft() async {
    final response = await getAuthenticated("gfffts/default");
    return Gffft.fromJson(response);
  }

  Future<GffftMembership> joinGffft(String uid, String gid, String mid) async {
    var membershipPost = GffftMembershipPost(uid: uid, gid: gid, mid: mid);

    print("member joining: " + jsonEncode(membershipPost));

    final response = await put("users/${uid}/gfffts/${gid}/members/${mid}", jsonEncode(membershipPost));
    return GffftMembership.fromJson(response);
  }

  Future<ThreadResult> getBoardThreads(String uid, String gid, String bid, String? offset, int? pageSize) async {
    final response = await getAuthenticated("users/${uid}/gfffts/${gid}/boards/${bid}/threads");
    return ThreadResult.fromJson(response);
  }
}
