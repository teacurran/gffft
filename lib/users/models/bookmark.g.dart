// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      gid: json['gid'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    )..gffft = json['gffft'] == null
        ? null
        : GffftMinimal.fromJson(json['gffft'] as Map<String, dynamic>);

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'gid': instance.gid,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'gffft': instance.gffft?.toJson(),
    };
