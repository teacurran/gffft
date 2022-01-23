// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gffft _$GffftFromJson(Map<String, dynamic> json) => Gffft(
      uid: json['uid'] as String,
      gid: json['gid'] as String,
      me: User.fromJson(json['me'] as Map<String, dynamic>),
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
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => GffftFeatureRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      boards: (json['boards'] as List<dynamic>?)
          ?.map((e) => Board.fromJson(e as Map<String, dynamic>))
          .toList(),
      membership: json['membership'] == null
          ? null
          : GffftMembership.fromJson(
              json['membership'] as Map<String, dynamic>),
      bookmark: json['bookmark'] == null
          ? null
          : Bookmark.fromJson(json['bookmark'] as Map<String, dynamic>),
    )
      ..calendars = (json['calendars'] as List<dynamic>?)
          ?.map((e) => Calendar.fromJson(e as Map<String, dynamic>))
          .toList()
      ..galleries = (json['galleries'] as List<dynamic>?)
          ?.map((e) => Gallery.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GffftToJson(Gffft instance) => <String, dynamic>{
      'uid': instance.uid,
      'gid': instance.gid,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'intro': instance.intro,
      'enabled': instance.enabled,
      'allowMembers': instance.allowMembers,
      'requireApproval': instance.requireApproval,
      'enableAltHandles': instance.enableAltHandles,
      'me': instance.me.toJson(),
      'boardEnabled': instance.boardEnabled,
      'calendarEnabled': instance.calendarEnabled,
      'galleryEnabled': instance.galleryEnabled,
      'notebookEnabled': instance.notebookEnabled,
      'features': instance.features?.map((e) => e.toJson()).toList(),
      'boards': instance.boards?.map((e) => e.toJson()).toList(),
      'calendars': instance.calendars?.map((e) => e.toJson()).toList(),
      'galleries': instance.galleries?.map((e) => e.toJson()).toList(),
      'membership': instance.membership?.toJson(),
      'bookmark': instance.bookmark?.toJson(),
    };
