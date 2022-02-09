import 'dart:async';
import 'dart:convert';

import '../api_base.dart';
import 'models/link_set.dart';
import 'models/link_submit.dart';

class LinkSetApi extends ApiBase {
  Future<LinkSet> getLinkSet(String uid, String gid, String lid, String? offset, int? pageSize) async {
    final response = await get("users/${uid}/gfffts/${gid}/links/${lid}");
    return LinkSet.fromJson(response);
  }

  Future<void> createLink(LinkSubmit p) async {
    return post("links/create", jsonEncode(p));
  }
}
