// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_submit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostSubmit _$PostSubmitFromJson(Map<String, dynamic> json) => PostSubmit(
      json['uid'] as String,
      json['gid'] as String,
      json['bid'] as String,
      json['body'] as String,
      pid: json['pid'] as String?,
      subject: json['subject'] as String?,
    );

Map<String, dynamic> _$PostSubmitToJson(PostSubmit instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'bid': instance.bid,
      'body': instance.body,
      'pid': instance.pid,
      'subject': instance.subject,
    };
