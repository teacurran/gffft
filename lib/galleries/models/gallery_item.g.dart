// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => GalleryItem(
      id: json['id'] as String,
      author: Participant.fromJson(json['author'] as Map<String, dynamic>),
      fileName: json['fileName'] as String,
      path: json['path'] as String,
      thumbnail: json['thumbnail'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'fileName': instance.fileName,
      'path': instance.path,
      'thumbnail': instance.thumbnail,
      'createdAt': instance.createdAt.toIso8601String(),
    };
