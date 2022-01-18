import 'package:json_annotation/json_annotation.dart';

part 'board.g.dart';

@JsonSerializable()
class Board {
  String? id;
  String? name;
  String? description;
  int threads;
  int posts;

  Board({required this.id, required this.name, this.description, required this.threads, required this.posts});

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
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
