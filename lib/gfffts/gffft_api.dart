import 'dart:convert';

import 'package:gffft/gfffts/gffft.dart';

import '../api_base.dart';

class GffftApi extends ApiBase {
  Future<void> save(Gffft gffft) async {
    return put("gfffts", jsonEncode(gffft));
  }

  Future<Gffft> getDefaultGffft() async {
    final response = await getAuthenticated("gfffts/default");
    return Gffft.fromJson(response);
  }
}
