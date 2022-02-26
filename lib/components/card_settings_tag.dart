import 'dart:convert';

import 'package:card_settings/helpers/platform_functions.dart';
import 'package:card_settings/interfaces/common_field_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:gffft/style/app_theme.dart';

import 'non_decorated_card_settings_field.dart';

class CardSettingsTag extends FormField<List<String>> implements ICommonFieldProperties {
  CardSettingsTag({
    Key? key,
    AutovalidateMode autoValidateModel = AutovalidateMode.onUserInteraction,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
    List<String>? initialItems,
    this.widgetEnabled = true,
    this.visible = true,
    this.label = "Label",
    this.labelWidth,
    this.requiredIndicator,
    this.labelAlign,
    this.icon,
    this.contentAlign,
    this.onChanged,
    this.showMaterialonIOS,
    this.fieldPadding,
    this.hintText,
  }) : super(
            key: key,
            initialValue: initialItems,
            onSaved: onSaved,
            validator: validator,
            // autovalidate: autovalidate,
            autovalidateMode: autoValidateModel,
            builder: (FormFieldState<List<String>> field) => (field as _CardSettingsTagState)._build(field.context));

  /// The text to identify the field to the user
  @override
  final String label;

  /// If false the field is grayed out and unresponsive
  final bool widgetEnabled;

  /// The alignment of the label paret of the field. Default is left.
  @override
  final TextAlign? labelAlign;

  /// The width of the field label. If provided overrides the global setting.
  @override
  final double? labelWidth;

  /// controls how the widget in the content area of the field is aligned
  @override
  final TextAlign? contentAlign;

  /// The icon to display to the left of the field content
  @override
  final Icon? icon;

  /// A widget to show next to the label if the field is required
  @override
  final Widget? requiredIndicator;

  /// Fires when the switch state is changed
  @override
  final ValueChanged<List<String>>? onChanged;

  /// If false hides the widget on the card setting panel
  @override
  final bool visible;

  /// Force the widget to use Material style on an iOS device
  @override
  final bool? showMaterialonIOS;

  /// provides padding to wrap the entire field
  @override
  final EdgeInsetsGeometry? fieldPadding;

  final String? hintText;

  @override
  _CardSettingsTagState createState() => _CardSettingsTagState();
}

class _CardSettingsTagState extends FormFieldState<List<String>> {
  @override
  CardSettingsTag get widget => super.widget as CardSettingsTag;

  bool initialized = false;
  List<String> items = <String>[];

  Widget _build(BuildContext context) {
    if (!initialized) {
      setState(() {
        if (widget.initialValue != null) {
          items = widget.initialValue!;
        }
        initialized = true;
      });
    }

    if (showCupertino(context, widget.showMaterialonIOS)) return _cupertinoSettingsTag(context);
    return _materialSettingsTag(context);
  }

  Widget _materialSettingsTag(BuildContext context) {
    return NonDecoratedCardSettingsField(
      label: widget.label,
      labelAlign: widget.labelAlign,
      labelWidth: widget.labelWidth,
      enabled: widget.widgetEnabled,
      visible: widget.visible,
      icon: widget.icon,
      requiredIndicator: widget.requiredIndicator,
      errorText: errorText,
      fieldPadding: widget.fieldPadding,
      contentOnNewLine: true,
      content: Tags(
        textField: _textField(context),
        itemCount: items.length,
        itemBuilder: (index) {
          final item = items[index];
          return ItemTags(
              key: Key(index.toString()),
              index: index,
              title: item,
              pressEnabled: true,
              activeColor: Colors.blueGrey.shade600,
              singleItem: false,
              splashColor: Colors.green,
              combine: ItemTagsCombine.withTextBefore,
              textScaleFactor: utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
              onPressed: (item) => print(item),
              removeButton: ItemTagsRemoveButton(
                onRemoved: () {
                  setState(() {
                    items.removeAt(index);
                  });
                  return true;
                },
              ));
        },
      ),
    );
  }

  Widget _cupertinoSettingsTag(BuildContext context) {
    return _materialSettingsTag(context);
  }

  TagsTextField _textField(BuildContext context) {
    final theme = context.appTheme.materialTheme;
    return TagsTextField(
      inputDecoration: const InputDecoration().applyDefaults(theme.inputDecorationTheme),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      enabled: true,
      constraintSuggestion: false,
      hintText: widget.hintText,
      onSubmitted: (String str) {
        str = str.toLowerCase();
        if (str.contains(" ")) {
          var splitStr = str.split(" ");
          for (var word in splitStr) {
            setState(() {
              items.add(word);
            });
          }
        } else {
          setState(() {
            items.add(str);
          });
        }
        if (widget.onChanged != null) {
          widget.onChanged!(items);
        }
      },
    );
  }
}
