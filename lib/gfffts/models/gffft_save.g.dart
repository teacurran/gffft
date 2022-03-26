// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftSave _$GffftSaveFromJson(Map<String, dynamic> json) => GffftSave(
      uid: json['uid'] as String,
      gid: json['gid'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      intro: json['intro'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      allowMembers: json['allowMembers'] as bool? ?? false,
      requireApproval: json['requireApproval'] as bool? ?? false,
      enableAltHandles: json['enableAltHandles'] as bool? ?? false,
      boardEnabled: json['boardEnabled'] as bool? ?? false,
      galleryEnabled: json['galleryEnabled'] as bool? ?? false,
      notebookEnabled: json['notebookEnabled'] as bool? ?? false,
      calendarEnabled: json['calendarEnabled'] as bool? ?? false,
      initialHandle: json['initialHandle'] as String?,
    );

Map<String, dynamic> _$GffftSaveToJson(GffftSave instance) => <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'intro': instance.intro,
      'initialHandle': instance.initialHandle,
      'enabled': instance.enabled,
      'allowMembers': instance.allowMembers,
      'requireApproval': instance.requireApproval,
      'enableAltHandles': instance.enableAltHandles,
      'boardEnabled': instance.boardEnabled,
      'calendarEnabled': instance.calendarEnabled,
      'galleryEnabled': instance.galleryEnabled,
      'notebookEnabled': instance.notebookEnabled,
    };
