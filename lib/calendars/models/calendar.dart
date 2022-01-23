import 'package:gffft/boards/models/participant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

@JsonSerializable(explicitToJson: true)
class Calendar {
  String id;
  DateTime updatedAt;
  String whoCanView;
  String whoCanPost;
  String? name;
  String? description;
  int events;
  Participant? latestPost;

  Calendar(
      {required this.id,
      required this.updatedAt,
      required this.whoCanView,
      required this.whoCanPost,
      required this.name,
      this.description,
      required this.events,
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
  factory Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CalendarToJson(this);
}
