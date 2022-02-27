import 'package:json_annotation/json_annotation.dart';

part 'gffft_update_counters.g.dart';

@JsonSerializable(explicitToJson: true)
class GffftUpdateCounters {
  int? galleryPhotos;
  int? galleryVideos;
  int? boardThreads;
  int? boardPosts;
  int? linkSetItems;

  GffftUpdateCounters({this.galleryPhotos, this.galleryVideos, this.boardThreads, this.boardPosts, this.linkSetItems});

  factory GffftUpdateCounters.fromJson(Map<String, dynamic> json) => _$GffftUpdateCountersFromJson(json);
  Map<String, dynamic> toJson() => _$GffftUpdateCountersToJson(this);
}
