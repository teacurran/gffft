// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftCreate _$GffftCreateFromJson(Map<String, dynamic> json) => GffftCreate(
      name: json['name'] as String,
      description: json['description'] as String,
      intro: json['intro'] as String?,
      initialHandle: json['initialHandle'] as String,
    );

Map<String, dynamic> _$GffftCreateToJson(GffftCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'intro': instance.intro,
      'initialHandle': instance.initialHandle,
    };
