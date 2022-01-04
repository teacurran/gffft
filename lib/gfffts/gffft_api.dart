import 'dart:convert';

import 'package:gffft/gfffts/gffft.dart';

import '../api_base.dart';
import 'gffft_result.dart';

class GffftApi extends ApiBase {
  Future<void> save(Gffft gffft) async {
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
}
