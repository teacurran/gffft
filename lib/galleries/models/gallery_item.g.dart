// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => GalleryItem(
      id: json['id'] as String,
      author: Participant.fromJson(json['author'] as Map<String, dynamic>),
      item: json['item'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'item': instance.item,
      'createdAt': instance.createdAt.toIso8601String(),
    };
