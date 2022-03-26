import 'package:gffft/gfffts/models/gffft_minimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable(explicitToJson: true)
class Bookmark {
  String? id;
  String? name;
  DateTime createdAt;
  GffftMinimal? gffft;

  Bookmark({this.id, required this.name, required this.createdAt});

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
}
