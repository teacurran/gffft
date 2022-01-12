import 'package:json_annotation/json_annotation.dart';

part 'gffft_membership_post.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftMembershipPost {
  final String uid;
  final String gid;
  final String mid;

  GffftMembershipPost({required this.uid, required this.gid, required this.mid});

  factory GffftMembershipPost.fromJson(Map<String, dynamic> json) => _$GffftMembershipPostFromJson(json);
  Map<String, dynamic> toJson() => _$GffftMembershipPostToJson(this);
}
