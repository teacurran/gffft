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
      firstPost:
          Participant.fromJson(json['firstPost'] as Map<String, dynamic>),
      latestPost: json['latestPost'] == null
          ? null
          : Participant.fromJson(json['latestPost'] as Map<String, dynamic>),
      postCount: json['postCount'] as int? ?? 0,
      topReaction: json['topReaction'] as String?,
      canEdit: json['canEdit'] as bool? ?? false,
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'firstPost': instance.firstPost.toJson(),
      'latestPost': instance.latestPost?.toJson(),
      'postCount': instance.postCount,
      'topReaction': instance.topReaction,
      'canEdit': instance.canEdit,
    };
