import 'package:json_annotation/json_annotation.dart';

part 'gffft_create.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftCreate {
  String name;
  String description;
  String? intro;
  String initialHandle;

  GffftCreate({this.name, this.description, this.intro, this.initialHandle});

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
  factory GffftCreate.fromJson(Map<String, dynamic> json) => _$GffftCreateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$GffftCreateToJson(this);
}
