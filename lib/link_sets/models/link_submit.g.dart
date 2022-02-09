// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkSubmit _$LinkSubmitFromJson(Map<String, dynamic> json) => LinkSubmit(
      json['uid'] as String,
      json['gid'] as String,
      json['lid'] as String,
      json['url'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$LinkSubmitToJson(LinkSubmit instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'lid': instance.lid,
      'url': instance.url,
      'description': instance.description,
    };
