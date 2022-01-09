// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadResult _$ThreadResultFromJson(Map<String, dynamic> json) => ThreadResult(
      count: json['count'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Thread.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Thread>[],
    );

Map<String, dynamic> _$ThreadResultToJson(ThreadResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
