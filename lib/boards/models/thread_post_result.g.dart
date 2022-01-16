// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_post_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPostResult _$ThreadPostResultFromJson(Map<String, dynamic> json) =>
    ThreadPostResult(
      count: json['count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThreadPostResultToJson(ThreadPostResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
