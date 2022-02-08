import 'package:flutter/material.dart';
import 'package:delphi_prog/models/data.dart';

class LineChart extends StatelessWidget {
  final Data data;

  LineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Line chart"));
  }
}
