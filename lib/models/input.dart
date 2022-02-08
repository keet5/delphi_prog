import 'package:flutter/material.dart';

class Input {
  final String title;
  final Function setValue;
  final Function getValue;
  final controller = TextEditingController();

  Input({required this.title, required this.setValue, required this.getValue}) {
    controller.text = getValue().toString();
  }
}
