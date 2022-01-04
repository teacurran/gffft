import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchInputSliver extends StatefulWidget {
  const SearchInputSliver({
    Key? key,
    required this.label,
    this.onChanged,
    this.debounceTime,
  }) : super(key: key);
  final String label;
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  _SearchInputSliverState createState() => _SearchInputSliverState();
}

class _SearchInputSliverState extends State<SearchInputSliver> {
  @override
  SearchInputSliver get widget => super.widget;

  final StreamController<String> _textChangeStreamController = StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
          widget.debounceTime ?? const Duration(seconds: 1),
        )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: widget.label,
              ),
              onChanged: (String value) {
                widget.onChanged!(value);
                _textChangeStreamController.add(value);
              }),
        ),
      );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
