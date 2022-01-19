import 'package:gffft/boards/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gallery_item.dart';

part 'gallery.g.dart';

@JsonSerializable(explicitToJson: true)
class Gallery {
  String? id;
  String? name;
  String? description;
  int photoCount;
  int videoCount;
  Participant? latestPost;
  DateTime createdAt;
  DateTime updatedAt;
  int count;
  List<GalleryItem> items;

  Gallery(
      {required this.id,
      this.name,
      this.description,
      this.photoCount = 0,
      this.videoCount = 0,
      this.latestPost,
      required this.createdAt,
      required this.updatedAt,
      this.count = 0,
      this.items = const <GalleryItem>[]});

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
  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GalleryToJson(this);
}
