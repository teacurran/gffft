import 'package:gffft/boards/models/board.dart';
import 'package:gffft/calendars/models/calendar.dart';
import 'package:gffft/galleries/models/gallery.dart';
import 'package:gffft/gfffts/models/gffft_feature_ref.dart';
import 'package:gffft/notebooks/models/notebook.dart';
import 'package:gffft/users/models/bookmark.dart';
import 'package:gffft/users/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../link_sets/models/link_set.dart';
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
  User? me;
  List<String> fruitCode;
  int rareFruits;
  int ultraRareFruits;

  List<GffftFeatureRef>? features;
  List<Board>? boards;
  List<Calendar>? calendars;
  List<Gallery>? galleries;
  List<Notebook>? notebooks;
  List<LinkSet>? linkSets;
  GffftMembership? membership;
  Bookmark? bookmark;

  Gffft(
      {required this.uid,
      required this.gid,
      required this.me,
      required this.fruitCode,
      this.name,
      this.description,
      this.tags,
      this.intro,
      this.enabled = false,
      this.allowMembers = false,
      this.requireApproval = false,
      this.enableAltHandles = false,
      this.features,
      this.boards,
      this.notebooks,
      this.linkSets,
      this.membership,
      this.bookmark,
      this.rareFruits = 0,
      this.ultraRareFruits = 0});

  bool hasFeature(String name) {
    if (features == null) {
      return false;
    }
    for (var i = 0; i < features!.length; i++) {
      if (features![i].type == name) {
        return true;
      }
    }

    return false;
  }

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
