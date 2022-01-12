// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftMembership _$GffftMembershipFromJson(Map<String, dynamic> json) =>
    GffftMembership(
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GffftMembershipToJson(GffftMembership instance) =>
    <String, dynamic>{
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
    };
