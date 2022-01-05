// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_minimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftMinimal _$GffftMinimalFromJson(Map<String, dynamic> json) => GffftMinimal(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      allowMembers: json['allowMembers'] as bool? ?? false,
      requireApproval: json['requireApproval'] as bool? ?? false,
      boardEnabled: json['boardEnabled'] as bool? ?? false,
      galleryEnabled: json['galleryEnabled'] as bool? ?? false,
      pagesEnabled: json['pagesEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$GffftMinimalToJson(GffftMinimal instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'enabled': instance.enabled,
      'allowMembers': instance.allowMembers,
      'requireApproval': instance.requireApproval,
      'boardEnabled': instance.boardEnabled,
      'galleryEnabled': instance.galleryEnabled,
      'pagesEnabled': instance.pagesEnabled,
    };
