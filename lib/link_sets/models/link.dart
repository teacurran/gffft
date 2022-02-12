import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable()
class Link {
  String id;
  String domain;
  String url;
  String? title;
  String? description;
  String? image;
  int responseCode;
  DateTime createdAt;
  DateTime updatedAt;

  Link(
      {required this.id,
      required this.domain,
      required this.url,
      this.title,
      this.description,
      this.image,
      required this.responseCode,
      required this.createdAt,
      required this.updatedAt});

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
  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
