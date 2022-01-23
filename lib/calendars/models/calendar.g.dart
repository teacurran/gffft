// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) => Calendar(
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      whoCanView: json['whoCanView'] as String,
      whoCanPost: json['whoCanPost'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      events: json['events'] as int,
      latestPost: json['latestPost'] == null
          ? null
          : Participant.fromJson(json['latestPost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CalendarToJson(Calendar instance) => <String, dynamic>{
      'id': instance.id,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'whoCanView': instance.whoCanView,
      'whoCanPost': instance.whoCanPost,
      'name': instance.name,
      'description': instance.description,
      'events': instance.events,
      'latestPost': instance.latestPost?.toJson(),
    };
