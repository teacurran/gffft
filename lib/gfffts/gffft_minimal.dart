import 'package:json_annotation/json_annotation.dart';

part 'gffft_minimal.g.dart';

@JsonSerializable()
class GffftMinimal {
  String? id;
  String? name;
  String? description;
  bool enabled;
  bool allowMembers;
  bool requireApproval;
  bool boardEnabled;
  bool galleryEnabled;
  bool pagesEnabled;

  GffftMinimal({
    this.id,
    this.name,
    this.description,
    this.enabled = false,
    this.allowMembers = false,
    this.requireApproval = false,
    this.boardEnabled = false,
    this.galleryEnabled = false,
    this.pagesEnabled = false,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(id: json['id'], username: json['username'], name: json['name']);
  // }

  // the above method can also be written as:
  // User.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       username = json['username'],
  //       name = json['name'];

  factory GffftMinimal.fromJson(Map<String, dynamic> json) => _$GffftMinimalFromJson(json);

  Map<String, dynamic> toJson() => _$GffftMinimalToJson(this);
}
