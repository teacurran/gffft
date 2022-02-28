// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_minimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftMinimal _$GffftMinimalFromJson(Map<String, dynamic> json) => GffftMinimal(
      uid: json['uid'] as String,
      gid: json['gid'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      allowMembers: json['allowMembers'] as bool? ?? false,
      requireApproval: json['requireApproval'] as bool? ?? false,
      boardEnabled: json['boardEnabled'] as bool? ?? false,
      galleryEnabled: json['galleryEnabled'] as bool? ?? false,
      pagesEnabled: json['pagesEnabled'] as bool? ?? false,
      bid: json['bid'] as String?,
    )..membership = json['membership'] == null
        ? null
        : GffftMembership.fromJson(json['membership'] as Map<String, dynamic>);

Map<String, dynamic> _$GffftMinimalToJson(GffftMinimal instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'name': instance.name,
      'description': instance.description,
      'enabled': instance.enabled,
      'allowMembers': instance.allowMembers,
      'requireApproval': instance.requireApproval,
      'boardEnabled': instance.boardEnabled,
      'galleryEnabled': instance.galleryEnabled,
      'pagesEnabled': instance.pagesEnabled,
      'bid': instance.bid,
      'membership': instance.membership,
    };
