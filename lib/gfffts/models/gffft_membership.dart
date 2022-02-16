import 'package:json_annotation/json_annotation.dart';

part 'gffft_membership.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftMembership {
  String type;
  DateTime createdAt;
  String? handle;

  GffftMembership({required this.type, required this.createdAt, this.handle});

  factory GffftMembership.fromJson(Map<String, dynamic> json) => _$GffftMembershipFromJson(json);
  Map<String, dynamic> toJson() => _$GffftMembershipToJson(this);
}
