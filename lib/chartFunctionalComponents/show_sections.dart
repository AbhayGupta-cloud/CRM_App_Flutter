import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/View/app_colors.dart';

List<PieChartSectionData> showingSections() {
  return List.generate(4, (i) {
    int touchedIndex = -1;
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: AppColors.contentColorBlue,
          value: 40,
          title: '40%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        );
      case 1:
        return PieChartSectionData(
          color: AppColors.contentColorYellow,
          value: 30,
          title: '30%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        );
      case 2:
        return PieChartSectionData(
          color: AppColors.contentColorPurple,
          value: 15,
          title: '15%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        );
      case 3:
        return PieChartSectionData(
          color: AppColors.contentColorGreen,
          value: 15,
          title: '15%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        );
      default:
        throw Error();
    }
  });
}
