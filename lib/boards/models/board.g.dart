// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      whoCanView: json['whoCanView'] as String,
      whoCanPost: json['whoCanPost'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      threads: json['threads'] as int,
      posts: json['posts'] as int,
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'id': instance.id,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'whoCanView': instance.whoCanView,
      'whoCanPost': instance.whoCanPost,
      'name': instance.name,
      'description': instance.description,
      'threads': instance.threads,
      'posts': instance.posts,
    };
