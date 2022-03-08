import 'package:json_annotation/json_annotation.dart';

part 'gallery_item_like_submit.g.dart';

@JsonSerializable(explicitToJson: true)
class GalleryItemLikeSubmit {
  String uid;
  String gid;
  String mid;
  String iid;

  GalleryItemLikeSubmit(this.uid, this.gid, this.mid, this.iid);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GalleryItemLikeSubmit.fromJson(Map<String, dynamic> json) => _$GalleryItemLikeSubmitFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GalleryItemLikeSubmitToJson(this);
}
