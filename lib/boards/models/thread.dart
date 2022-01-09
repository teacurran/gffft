import 'package:json_annotation/json_annotation.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  String id;
  String subject;
  DateTime createdAt;
  DateTime updatedAt;
  String? topReaction;

  Thread({required this.id, required this.subject, required this.createdAt, required this.updatedAt, this.topReaction});

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
  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ThreadToJson(this);
}
