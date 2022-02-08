import 'package:flutter/material.dart';
import 'package:delphi_prog/models/data.dart';

class TableChart extends StatelessWidget {
  final Data data;

  TableChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Table chart"),
    );
  }
}
