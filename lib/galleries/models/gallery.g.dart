// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      photoCount: json['photoCount'] as int? ?? 0,
      videoCount: json['videoCount'] as int? ?? 0,
      latestPost: json['latestPost'] == null
          ? null
          : Participant.fromJson(json['latestPost'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      whoCanView: json['whoCanView'] as String,
      whoCanPost: json['whoCanPost'] as String,
      count: json['count'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GalleryItem>[],
    );

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoCount': instance.photoCount,
      'videoCount': instance.videoCount,
      'latestPost': instance.latestPost?.toJson(),
      'whoCanView': instance.whoCanView,
      'whoCanPost': instance.whoCanPost,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'count': instance.count,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
