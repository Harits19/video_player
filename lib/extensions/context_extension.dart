import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

}
