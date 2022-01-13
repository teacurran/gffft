import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable(explicitToJson: true)
class Bookmark {
  String gid;
  String name;
  DateTime createdAt;

  Bookmark({required this.gid, required this.name, required this.createdAt});

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
