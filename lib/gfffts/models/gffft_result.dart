import 'package:json_annotation/json_annotation.dart';

import 'gffft_minimal.dart';

part 'gffft_result.g.dart';

@JsonSerializable()
class GffftResult {
  int count;
  List<GffftMinimal> items;

  GffftResult({
    this.count = 0,
    this.items = const <GffftMinimal>[],
  });

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
  factory GffftResult.fromJson(Map<String, dynamic> json) => _$GffftResultFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$GffftResultToJson(this);
}
