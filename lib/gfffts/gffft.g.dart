// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gffft _$GffftFromJson(Map<String, dynamic> json) => Gffft(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      intro: json['intro'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      allowMembers: json['allowMembers'] as bool? ?? false,
      requireApproval: json['requireApproval'] as bool? ?? false,
      enableAltHandles: json['enableAltHandles'] as bool? ?? false,
      boardEnabled: json['boardEnabled'] as bool? ?? false,
      boardWhoCanView: json['boardWhoCanView'] as String?,
      boardWhoCanPost: json['boardWhoCanPost'] as String?,
      galleryEnabled: json['galleryEnabled'] as bool? ?? false,
      galleryWhoCanView: json['galleryWhoCanView'] as String?,
      galleryWhoCanPost: json['galleryWhoCanPost'] as String?,
      pagesEnabled: json['pagesEnabled'] as bool? ?? false,
      pagesWhoCanView: json['pagesWhoCanView'] as String?,
      pagesWhoCanEdit: json['pagesWhoCanEdit'] as String?,
    );

Map<String, dynamic> _$GffftToJson(Gffft instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'intro': instance.intro,
      'enabled': instance.enabled,
      'allowMembers': instance.allowMembers,
      'requireApproval': instance.requireApproval,
      'enableAltHandles': instance.enableAltHandles,
      'boardEnabled': instance.boardEnabled,
      'boardWhoCanView': instance.boardWhoCanView,
      'boardWhoCanPost': instance.boardWhoCanPost,
      'galleryEnabled': instance.galleryEnabled,
      'galleryWhoCanView': instance.galleryWhoCanView,
      'galleryWhoCanPost': instance.galleryWhoCanPost,
      'pagesEnabled': instance.pagesEnabled,
      'pagesWhoCanView': instance.pagesWhoCanView,
      'pagesWhoCanEdit': instance.pagesWhoCanEdit,
    };
