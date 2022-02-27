// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gffft_update_counters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GffftUpdateCounters _$GffftUpdateCountersFromJson(Map<String, dynamic> json) =>
    GffftUpdateCounters(
      galleryPhotos: json['galleryPhotos'] as int?,
      galleryVideos: json['galleryVideos'] as int?,
      boardThreads: json['boardThreads'] as int?,
      boardPosts: json['boardPosts'] as int?,
      linkSetItems: json['linkSetItems'] as int?,
    );

Map<String, dynamic> _$GffftUpdateCountersToJson(
        GffftUpdateCounters instance) =>
    <String, dynamic>{
      'galleryPhotos': instance.galleryPhotos,
      'galleryVideos': instance.galleryVideos,
      'boardThreads': instance.boardThreads,
      'boardPosts': instance.boardPosts,
      'linkSetItems': instance.linkSetItems,
    };
