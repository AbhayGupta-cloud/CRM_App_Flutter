import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/View/app_colors.dart';
import 'package:login_signup_page/widgets/bottom_title_widget.dart';
import 'package:login_signup_page/widgets/left_title_widgets.dart';

LineChartData mainData() {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  //Process leadsData and create LineChartData Here
  //The 'LeadsData' should be a map of DateTime and lead count.

  //Example

  // final lineBarsData = [
  //   LineChartBarData(
  //     // Spots based on leadsData
  //     spots: leadsData.entries.map((entry) {
  //       final x = entry.key.day.toDouble();
  //       final y = entry.value.toDouble();
  //       return FlSpot(x, y);
  //     }).toList(),
  //   ),
  // ];
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 42,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: const Color(0xff37434d)),
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ],
  );
}
