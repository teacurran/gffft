import 'package:gffft/boards/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notebook.g.dart';

@JsonSerializable(explicitToJson: true)
class Notebook {
  String id;
  DateTime updatedAt;
  String whoCanView;
  String whoCanPost;
  String? name;
  String? description;
  int pages;
  Participant? latestPost;

  Notebook(
      {required this.id,
      required this.updatedAt,
      required this.whoCanView,
      required this.whoCanPost,
      required this.name,
      this.description,
      required this.pages,
      this.latestPost});

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
  factory Notebook.fromJson(Map<String, dynamic> json) => _$NotebookFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NotebookToJson(this);
}
