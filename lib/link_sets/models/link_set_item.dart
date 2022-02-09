import 'package:gffft/boards/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'link_set_item.g.dart';

@JsonSerializable()
class LinkSetItem {
  String id;
  Participant author;
  String url;
  String description;
  DateTime createdAt;

  LinkSetItem(
      {required this.id, required this.author, required this.url, required this.description, required this.createdAt});

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
  factory LinkSetItem.fromJson(Map<String, dynamic> json) => _$LinkSetItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LinkSetItemToJson(this);
}
