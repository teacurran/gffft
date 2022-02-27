// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftMembership _$GffftMembershipFromJson(Map<String, dynamic> json) =>
    GffftMembership(
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      handle: json['handle'] as String?,
    )..updateCounters = json['updateCounters'] == null
        ? null
        : GffftUpdateCounters.fromJson(
            json['updateCounters'] as Map<String, dynamic>);

Map<String, dynamic> _$GffftMembershipToJson(GffftMembership instance) =>
    <String, dynamic>{
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'handle': instance.handle,
      'updateCounters': instance.updateCounters?.toJson(),
    };
