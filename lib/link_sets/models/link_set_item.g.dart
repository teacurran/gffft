// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_set_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkSetItem _$LinkSetItemFromJson(Map<String, dynamic> json) => LinkSetItem(
      id: json['id'] as String,
      author: Participant.fromJson(json['author'] as Map<String, dynamic>),
      url: json['url'] as String,
      description: json['description'] as String,
      title: json['title'] as String?,
      blurb: json['blurb'] as String?,
      domain: json['domain'] as String?,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LinkSetItemToJson(LinkSetItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'url': instance.url,
      'description': instance.description,
      'domain': instance.domain,
      'title': instance.title,
      'blurb': instance.blurb,
      'image': instance.image,
      'createdAt': instance.createdAt.toIso8601String(),
    };
