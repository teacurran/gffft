import 'package:gffft/boards/models/thread.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadResult {
  int count;
  List<Thread> items;

  ThreadResult({
    this.count = 0,
    this.items = const <Thread>[],
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
  factory ThreadResult.fromJson(Map<String, dynamic> json) => _$ThreadResultFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$ThreadResultToJson(this);
}
