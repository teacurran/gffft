// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_patch_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftPatchSave _$GffftPatchSaveFromJson(Map<String, dynamic> json) =>
    GffftPatchSave(
      uid: json['uid'] as String,
      gid: json['gid'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      intro: json['intro'] as String?,
    )..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$GffftPatchSaveToJson(GffftPatchSave instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'gid': instance.gid,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('tags', instance.tags);
  writeNotNull('intro', instance.intro);
  writeNotNull('enabled', instance.enabled);
  return val;
}
