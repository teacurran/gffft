// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkSet _$LinkSetFromJson(Map<String, dynamic> json) => LinkSet(
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      whoCanView: json['whoCanView'] as String,
      whoCanPost: json['whoCanPost'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      itemCount: json['itemCount'] as int,
    );

Map<String, dynamic> _$LinkSetToJson(LinkSet instance) => <String, dynamic>{
      'id': instance.id,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'whoCanView': instance.whoCanView,
      'whoCanPost': instance.whoCanPost,
      'name': instance.name,
      'description': instance.description,
      'itemCount': instance.itemCount,
    };
