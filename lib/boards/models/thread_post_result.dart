import 'package:gffft/boards/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_post_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadPostResult {
  int count;
  List<Post> items;

  ThreadPostResult({
    required this.count,
    required this.items,
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
