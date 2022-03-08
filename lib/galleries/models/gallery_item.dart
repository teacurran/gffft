import 'package:gffft/boards/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery_item.g.dart';

@JsonSerializable()
class GalleryItem {
  String id;
  Participant author;
  String fileName;
  String filePath;
  bool thumbnail;
  DateTime createdAt;
  String? description;
  Map<String, String> urls;
  int? likeCount;
  bool? liked;

  GalleryItem(
      {required this.id,
      required this.author,
      required this.fileName,
      required this.filePath,
      required this.thumbnail,
      required this.createdAt,
      required this.urls,
      this.description,
      this.likeCount,
      this.liked});

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
  factory GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GalleryItemToJson(this);
}
