import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10K';
      break;
    case 3:
      text = '30k';
      break;
    case 5:
      text = '50k';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
