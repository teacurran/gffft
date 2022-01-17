import 'package:json_annotation/json_annotation.dart';

part 'post_submit.g.dart';

@JsonSerializable()
class PostSubmit {
  String uid;
  String gid;
  String bid;
  String body;
  String? tid;
  String? subject;

  PostSubmit(this.uid, this.gid, this.bid, this.body, {this.tid, this.subject});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PostSubmit.fromJson(Map<String, dynamic> json) => _$PostSubmitFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PostSubmitToJson(this);
}
