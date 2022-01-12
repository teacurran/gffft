import 'package:gffft/boards/models/board.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gffft_membership.dart';

part 'gffft.g.dart';

@JsonSerializable(explicitToJson: true)
class Gffft {
  String uid;
  String gid;
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

  List<GffftFeatureRef>? features;
  List<Board>? boards;
  GffftMembership? membership;

  Gffft(
      {required this.uid,
      required this.gid,
      this.name,
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
      this.calendarEnabled = false,
      this.features,
      this.boards});

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
