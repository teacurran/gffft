import 'package:gffft/gfffts/gffft.dart';

import '../api_base.dart';

class GffftApi extends ApiBase {
  save(Gffft gffft) {}

  Future<Gffft> getDefaultGffft() async {
    final response = await getAuthenticated("gfffts/default");
    return Gffft.fromJson(response);
  }
}
