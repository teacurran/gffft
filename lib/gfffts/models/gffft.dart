import 'package:json_annotation/json_annotation.dart';

part 'gffft.g.dart';

@JsonSerializable()
class Gffft {
  String? id;
  String? name;
  String? description;
  List<String>? tags;
  String? intro;
  bool enabled;
  bool allowMembers;
  bool requireApproval;
  bool enableAltHandles;

  bool boardEnabled;
  String? boardWhoCanView;
  String? boardWhoCanPost;

  bool galleryEnabled;
  String? galleryWhoCanView;
  String? galleryWhoCanPost;

  bool pagesEnabled;
  String? pagesWhoCanView;
  String? pagesWhoCanEdit;

  Gffft(
      {this.id,
      this.name,
      this.description,
      this.tags,
      this.intro,
      this.enabled = false,
      this.allowMembers = false,
      this.requireApproval = false,
      this.enableAltHandles = false,
      this.boardEnabled = false,
      this.boardWhoCanView,
      this.boardWhoCanPost,
      this.galleryEnabled = false,
      this.galleryWhoCanView,
      this.galleryWhoCanPost,
      this.pagesEnabled = false,
      this.pagesWhoCanView,
      this.pagesWhoCanEdit});

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
  factory Gffft.fromJson(Map<String, dynamic> json) => _$GffftFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$GffftToJson(this);
}
