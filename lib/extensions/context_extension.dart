import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void push(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
