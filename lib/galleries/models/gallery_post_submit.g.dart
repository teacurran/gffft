// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_post_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryPostSubmit _$GalleryPostSubmitFromJson(Map<String, dynamic> json) =>
    GalleryPostSubmit(
      json['uid'] as String,
      json['gid'] as String,
      json['mid'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GalleryPostSubmitToJson(GalleryPostSubmit instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'mid': instance.mid,
      'description': instance.description,
    };
