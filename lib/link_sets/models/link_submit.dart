import 'package:json_annotation/json_annotation.dart';

part 'link_submit.g.dart';

@JsonSerializable()
class LinkSubmit {
  String uid;
  String gid;
  String lid;
  String url;
  String? description;

  LinkSubmit(this.uid, this.gid, this.lid, this.url, {this.description});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory LinkSubmit.fromJson(Map<String, dynamic> json) => _$LinkSubmitFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LinkSubmitToJson(this);
}
