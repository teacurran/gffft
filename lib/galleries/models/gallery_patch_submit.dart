import 'package:json_annotation/json_annotation.dart';

part 'gallery_patch_submit.g.dart';

@JsonSerializable(explicitToJson: true)
class GalleryPatchSubmit {
  String uid;
  String gid;
  String mid;
  String iid;
  String? description;

  GalleryPatchSubmit(this.uid, this.gid, this.mid, this.iid, {this.description});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GalleryPatchSubmit.fromJson(Map<String, dynamic> json) => _$GalleryPatchSubmitFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GalleryPatchSubmitToJson(this);
}
