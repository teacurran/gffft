// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_post_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPostResult _$ThreadPostResultFromJson(Map<String, dynamic> json) =>
    ThreadPostResult(
      id: json['id'] as String,
      subject: json['subject'] as String,
      createdAt:
          const DateTimeConverter().fromJson(json['createdAt'] as String),
      updatedAt:
          const DateTimeConverter().fromJson(json['updatedAt'] as String),
      firstPost:
          Participant.fromJson(json['firstPost'] as Map<String, dynamic>),
      latestPost: json['latestPost'] == null
          ? null
          : Participant.fromJson(json['latestPost'] as Map<String, dynamic>),
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      postCount: json['postCount'] as int? ?? 0,
      topReaction: json['topReaction'] as String?,
    );

Map<String, dynamic> _$ThreadPostResultToJson(ThreadPostResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
      'firstPost': instance.firstPost.toJson(),
      'latestPost': instance.latestPost?.toJson(),
      'postCount': instance.postCount,
      'topReaction': instance.topReaction,
      'posts': instance.posts.map((e) => e.toJson()).toList(),
    };
