import 'package:json_annotation/json_annotation.dart';

part 'gffft_patch_save.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class GffftPatchSave {
  String uid;
  String gid;
  String? name;
  String? description;
  List<String>? tags;
  String? intro;
  bool? enabled;
  bool? allowMembers;
  bool? boardEnabled;

  GffftPatchSave(
      {required this.uid,
      required this.gid,
      this.name,
      this.description,
      this.tags,
      this.intro,
      this.enabled,
      this.allowMembers,
      this.boardEnabled});

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(id: json['id'], username: json['username'], name: json['name']);
  // }

  // the above method can also be written as:
  // User.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       username = json['username'],
  //       name = json['name'];

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GffftPatchSave.fromJson(Map<String, dynamic> json) => _$GffftPatchSaveFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$GffftPatchSaveToJson(this);
}
