// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_patch_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryPatchSubmit _$GalleryPatchSubmitFromJson(Map<String, dynamic> json) =>
    GalleryPatchSubmit(
      json['uid'] as String,
      json['gid'] as String,
      json['mid'] as String,
      json['iid'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GalleryPatchSubmitToJson(GalleryPatchSubmit instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'mid': instance.mid,
      'iid': instance.iid,
      'description': instance.description,
    };
