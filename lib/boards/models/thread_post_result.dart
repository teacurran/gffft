import 'package:gffft/boards/models/participant.dart';
import 'package:gffft/boards/models/post.dart';
import 'package:gffft/common/dates.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_post_result.g.dart';

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class ThreadPostResult {
  String id;
  String subject;
  DateTime createdAt;
  DateTime updatedAt;
  Participant firstPost;
  Participant? latestPost;
  int postCount;
  String? topReaction;
  List<Post> posts;

  ThreadPostResult({
    required this.id,
    required this.subject,
    required this.createdAt,
    required this.updatedAt,
    required this.firstPost,
    required this.latestPost,
    required this.posts,
    this.postCount = 0,
    this.topReaction,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ThreadPostResult.fromJson(Map<String, dynamic> json) => _$ThreadPostResultFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$GffftToJson`.
  Map<String, dynamic> toJson() => _$ThreadPostResultToJson(this);
}
