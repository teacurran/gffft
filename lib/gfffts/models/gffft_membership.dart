import 'package:json_annotation/json_annotation.dart';

import 'gffft_update_counters.dart';

part 'gffft_membership.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftMembership {
  String type;
  DateTime createdAt;
  String? handle;
  GffftUpdateCounters? updateCounters;
  int updateCount;

  GffftMembership({required this.type, required this.createdAt, this.handle, required this.updateCount});

  factory GffftMembership.fromJson(Map<String, dynamic> json) => _$GffftMembershipFromJson(json);
  Map<String, dynamic> toJson() => _$GffftMembershipToJson(this);
}
