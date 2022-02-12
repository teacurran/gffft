import 'dart:async';
import 'dart:convert';

import '../api_base.dart';
import 'models/link.dart';
import 'models/link_set.dart';
import 'models/link_submit.dart';

class LinkSetApi extends ApiBase {
  Future<LinkSet> getLinkSet(String uid, String gid, String lid, String? offset, int? max) async {
    var params = <String, String>{};
    if (offset != null) {
      params['offset'] = offset;
    }
    if (max != null) {
      params['max'] = max.toString();
    }

    final response = await get("users/${uid}/gfffts/${gid}/links/${lid}", queryParams: params);
    return LinkSet.fromJson(response);
  }

  Future<void> createLink(LinkSubmit p) async {
    return post("links", jsonEncode(p));
  }

  Future<Link> getLink(String url) async {
    var params = <String, String>{"url": url};
    final response = await get("links/link", queryParams: params);
    return Link.fromJson(response);
  }
}
