// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkResult _$BookmarkResultFromJson(Map<String, dynamic> json) =>
    BookmarkResult(
      count: json['count'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Bookmark>[],
      isHosting: json['isHosting'] as bool? ?? false,
    );

Map<String, dynamic> _$BookmarkResultToJson(BookmarkResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'isHosting': instance.isHosting,
    };
