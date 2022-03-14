import 'package:json_annotation/json_annotation.dart';

part 'gallery_item_patch_submit.g.dart';

@JsonSerializable(explicitToJson: true)
class GalleryItemPatchSubmit {
  String? description;

  GalleryItemPatchSubmit(this.description);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GalleryItemPatchSubmit.fromJson(Map<String, dynamic> json) => _$GalleryItemPatchSubmitFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GalleryItemPatchSubmitToJson(this);
}
