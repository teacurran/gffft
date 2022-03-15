import 'package:json_annotation/json_annotation.dart';

import 'bookmark.dart';

part 'bookmark_result.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkResult {
  int count;
  List<Bookmark> items;
  bool isHosting;

  BookmarkResult({this.count = 0, this.items = const <Bookmark>[], this.isHosting = false});

  factory BookmarkResult.fromJson(Map<String, dynamic> json) => _$BookmarkResultFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkResultToJson(this);
}
