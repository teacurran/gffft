// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notebook _$NotebookFromJson(Map<String, dynamic> json) => Notebook(
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      whoCanView: json['whoCanView'] as String,
      whoCanPost: json['whoCanPost'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      pages: json['pages'] as int,
      latestPost: json['latestPost'] == null
          ? null
          : Participant.fromJson(json['latestPost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotebookToJson(Notebook instance) => <String, dynamic>{
      'id': instance.id,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'whoCanView': instance.whoCanView,
      'whoCanPost': instance.whoCanPost,
      'name': instance.name,
      'description': instance.description,
      'pages': instance.pages,
      'latestPost': instance.latestPost?.toJson(),
    };
