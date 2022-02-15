// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => GalleryItem(
      id: json['id'] as String,
      author: Participant.fromJson(json['author'] as Map<String, dynamic>),
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      thumbnail: json['thumbnail'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      urls: Map<String, String>.from(json['urls'] as Map),
    );

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'thumbnail': instance.thumbnail,
      'createdAt': instance.createdAt.toIso8601String(),
      'urls': instance.urls,
    };
