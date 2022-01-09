// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      id: json['id'] as String,
      subject: json['subject'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      topReaction: json['topReaction'] as String?,
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'topReaction': instance.topReaction,
    };
