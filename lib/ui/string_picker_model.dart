import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';

class StringPickerModel extends PickerModel {
  final String code;
  const StringPickerModel(String name, this.code, {Icon? icon}) : super(name, code: code, icon: icon);
}
