import "package:intl/intl.dart";
import 'package:json_annotation/json_annotation.dart';

final DATE_FORMAT_EU = new DateFormat("yyyy-MM-dd");
final DATE_TIME_FORMAT = new DateFormat("yyyy-MM-dd hh:mm");

String formatDateTime(DateTime value) {
  final DateFormat shortFormat = DateFormat('hh:mm a');
  final DateFormat mediumFormat = DateFormat('MM/dd - hh:mm a');
  final DateFormat longFormat = DateFormat('MM/dd/yy - hh:mm a');

  final dateNow = DateTime.now();

  if (dateNow.difference(value).inDays == 0) {
    return shortFormat.format(value.toLocal());
  } else if (dateNow.difference(value).inDays > 365) {
    return longFormat.format(value.toLocal());
  }

  return mediumFormat.format(value.toLocal());
}

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
