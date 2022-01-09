import 'package:json_annotation/json_annotation.dart';

part 'gffft_save.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftSave {
  String? name;
  String? description;
  List<String>? tags;
  String? intro;
  bool enabled;
  bool allowMembers;
  bool requireApproval;
  bool enableAltHandles;

  bool boardEnabled;
  bool calendarEnabled;
  bool galleryEnabled;
  bool notebookEnabled;

  GffftSave(
      {this.name,
      this.description,
      this.tags,
      this.intro,
      this.enabled = false,
      this.allowMembers = false,
      this.requireApproval = false,
      this.enableAltHandles = false,
      this.boardEnabled = false,
      this.galleryEnabled = false,
      this.notebookEnabled = false,
      this.calendarEnabled = false});

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
  factory GffftSave.fromJson(Map<String, dynamic> json) => _$GffftSaveFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$GffftSaveToJson(this);
}
