// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftResult _$GffftResultFromJson(Map<String, dynamic> json) => GffftResult(
      count: json['count'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => GffftMinimal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GffftMinimal>[],
    );

Map<String, dynamic> _$GffftResultToJson(GffftResult instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
    };
