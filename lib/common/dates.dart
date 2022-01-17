import "package:intl/intl.dart";
import 'package:json_annotation/json_annotation.dart';

final DATE_FORMAT_EU = new DateFormat("yyyy-MM-dd");
final DATE_TIME_FORMAT = new DateFormat("yyyy-MM-dd hh:mm");

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    print("checking json: $json");
    if (json.contains(".")) {
      json = json.substring(0, json.length - 1);
    }

    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime json) => json.toIso8601String();
}
