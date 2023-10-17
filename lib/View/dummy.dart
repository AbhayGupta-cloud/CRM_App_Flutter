// // LineChartData mainData() {
// //     //Process leadsData and create LineChartData Here
// //     //The 'LeadsData' should be a map of DateTime and lead count.

// //     //Example

// //     // final lineBarsData = [
// //     //   LineChartBarData(
// //     //     // Spots based on leadsData
// //     //     spots: leadsData.entries.map((entry) {
// //     //       final x = entry.key.day.toDouble();
// //     //       final y = entry.value.toDouble();
// //     //       return FlSpot(x, y);
// //     //     }).toList(),
// //     //   ),
// //     // ];
// //     return LineChartData(
// //       gridData: FlGridData(
// //         show: true,
// //         drawVerticalLine: true,
// //         horizontalInterval: 1,
// //         verticalInterval: 1,
// //         getDrawingHorizontalLine: (value) {
// //           return const FlLine(
// //             color: AppColors.mainGridLineColor,
// //             strokeWidth: 1,
// //           );
// //         },
// //         getDrawingVerticalLine: (value) {
// //           return const FlLine(
// //             color: AppColors.mainGridLineColor,
// //             strokeWidth: 1,
// //           );
// //         },
// //       ),
// //       titlesData: FlTitlesData(
// //         show: true,
// //         rightTitles: const AxisTitles(
// //           sideTitles: SideTitles(showTitles: false),
// //         ),
// //         topTitles: const AxisTitles(
// //           sideTitles: SideTitles(showTitles: false),
// //         ),
// //         bottomTitles: AxisTitles(
// //           sideTitles: SideTitles(
// //             showTitles: true,
// //             reservedSize: 30,
// //             interval: 1,
// //             getTitlesWidget: bottomTitleWidgets,
// //           ),
// //         ),
// //         leftTitles: AxisTitles(
// //           sideTitles: SideTitles(
// //             showTitles: true,
// //             interval: 1,
// //             getTitlesWidget: leftTitleWidgets,
// //             reservedSize: 42,
// //           ),
// //         ),
// //       ),
// //       borderData: FlBorderData(
// //         show: true,
// //         border: Border.all(color: const Color(0xff37434d)),
// //       ),
// //       minX: 0,
// //       maxX: 11,
// //       minY: 0,
// //       maxY: 6,
// //       lineBarsData: [
// //         LineChartBarData(
// //           spots: const [
// //             FlSpot(0, 3),
// //             FlSpot(2.6, 2),
// //             FlSpot(4.9, 5),
// //             FlSpot(6.8, 3.1),
// //             FlSpot(8, 4),
// //             FlSpot(9.5, 3),
// //             FlSpot(11, 4),
// //           ],
// //           isCurved: true,
// //           gradient: LinearGradient(
// //             colors: gradientColors,
// //           ),
// //           barWidth: 5,
// //           isStrokeCapRound: true,
// //           dotData: const FlDotData(
// //             show: false,
// //           ),
// //           belowBarData: BarAreaData(
// //             show: true,
// //             gradient: LinearGradient(
// //               colors: gradientColors
// //                   .map((color) => color.withOpacity(0.3))
// //                   .toList(),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //combined chart

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:login_signup_page/View/app_colors.dart';
// // import 'package:login_signup_page/chartFunctionalComponents/line_chart_function.dart';
// // import 'package:login_signup_page/chartFunctionalComponents/main_data.dart';
// // import 'package:login_signup_page/chartFunctionalComponents/show_sections.dart';
// // import 'package:login_signup_page/widgets/indicator.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: MyChartPage(),
// //     );
// //   }
// // }

// // class MyChartPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Combined Line and Pie Charts'),
// //       ),
// //       body: ChartScreen(),
// //     );
// //   }
// // }

// // class ChartScreen extends StatefulWidget {
// //   @override
// //   _ChartScreenState createState() => _ChartScreenState();
// // }

// // class _ChartScreenState extends State<ChartScreen> {
// //   List<Color> gradientColors = [
// //     AppColors.contentColorCyan,
// //     AppColors.contentColorBlue,
// //   ];

// //   bool showAvg = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         // First Half: Line Chart
// //         Expanded(
// //           child: Stack(
// //             children: <Widget>[
// //               // Title
// //               SizedBox(
// //                 height: 10,
// //               ),
// //               Center(
// //                 child: Positioned(
// //                   top: 8, // Adjust the top position as needed
// //                   left: 12, // Adjust the left position as needed
// //                   child: Text(
// //                     'Line Bar Chart',
// //                     style: TextStyle(
// //                       fontSize: 18, // Adjust the font size as needed
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               // Wrap your LineChart in a Container with the desired height
// //               Container(
// //                 height: MediaQuery.of(context).size.height /
// //                     2, // Half of the screen height
// //                 child: AspectRatio(
// //                   aspectRatio: 1.70,
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(
// //                       right: 18,
// //                       left: 12,
// //                       top: 24,
// //                       bottom: 12,
// //                     ),
// //                     child: LineChart(
// //                       showAvg ? avgData() : mainData(),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 width: 60,
// //                 height: 34,
// //                 child: TextButton(
// //                   onPressed: () {
// //                     setState(() {
// //                       showAvg = !showAvg;
// //                     });
// //                   },
// //                   child: Text(
// //                     'avg',
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: showAvg
// //                           ? Colors.white.withOpacity(0.5)
// //                           : Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         // Second Half: Pie Chart
// //         Expanded(
// //           child: PieChartSample2(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class PieChartSample2 extends StatefulWidget {
// //   const PieChartSample2({super.key});

// //   @override
// //   State<StatefulWidget> createState() => PieChart2State();
// // }

// // class PieChart2State extends State {
// //   int touchedIndex = -1;

// //   @override
// //   Widget build(BuildContext context) {
// //     return AspectRatio(
// //       aspectRatio: 1.3,
// //       child: Row(
// //         children: <Widget>[
// //           const SizedBox(
// //             height: 18,
// //           ),
// //           Expanded(
// //             child: AspectRatio(
// //               aspectRatio: 1,
// //               child: PieChart(
// //                 PieChartData(
// //                   pieTouchData: PieTouchData(
// //                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
// //                       setState(() {
// //                         if (!event.isInterestedForInteractions ||
// //                             pieTouchResponse == null ||
// //                             pieTouchResponse.touchedSection == null) {
// //                           touchedIndex = -1;
// //                           return;
// //                         }
// //                         touchedIndex = pieTouchResponse
// //                             .touchedSection!.touchedSectionIndex;
// //                       });
// //                     },
// //                   ),
// //                   borderData: FlBorderData(
// //                     show: false,
// //                   ),
// //                   sectionsSpace: 0,
// //                   centerSpaceRadius: 40,
// //                   sections: showingSections(),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const Column(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: <Widget>[
// //               Indicator(
// //                 color: AppColors.contentColorBlue,
// //                 text: 'First',
// //                 isSquare: true,
// //               ),
// //               SizedBox(
// //                 height: 4,
// //               ),
// //               Indicator(
// //                 color: AppColors.contentColorYellow,
// //                 text: 'Second',
// //                 isSquare: true,
// //               ),
// //               SizedBox(
// //                 height: 4,
// //               ),
// //               Indicator(
// //                 color: AppColors.contentColorPurple,
// //                 text: 'Third',
// //                 isSquare: true,
// //               ),
// //               SizedBox(
// //                 height: 4,
// //               ),
// //               Indicator(
// //                 color: AppColors.contentColorGreen,
// //                 text: 'Fourth',
// //                 isSquare: true,
// //               ),
// //               SizedBox(
// //                 height: 18,
// //               ),
// //             ],
// //           ),
// //           const SizedBox(
// //             width: 28,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // String getCurrentUserUid() {
// //   final user = FirebaseAuth.instance.currentUser;
// //   if (user != null) {
// //     return user.uid;
// //   } else {
// //     // Handle the case when there is no authenticated user.
// //     // You might return null or an empty string, or handle it differently based on your app's requirements.
// //     return '';
// //   }
// // }

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart_app/presentation/widgets/indicator.dart';
// import 'package:flutter/material.dart';

// class PieChartSample2 extends StatefulWidget {
//   const PieChartSample2({super.key});

//   @override
//   State<StatefulWidget> createState() => PieChart2State();
// }

// class PieChart2State extends State {
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Row(
//         children: <Widget>[
//           const SizedBox(
//             height: 18,
//           ),
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: PieChart(
//                 PieChartData(
//                   pieTouchData: PieTouchData(
//                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                       setState(() {
//                         if (!event.isInterestedForInteractions ||
//                             pieTouchResponse == null ||
//                             pieTouchResponse.touchedSection == null) {
//                           touchedIndex = -1;
//                           return;
//                         }
//                         touchedIndex = pieTouchResponse
//                             .touchedSection!.touchedSectionIndex;
//                       });
//                     },
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 40,
//                   sections: showingSections(),
//                 ),
//               ),
//             ),
//           ),
//           const Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Indicator(
//                 color: AppColors.contentColorBlue,
//                 text: 'First',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorYellow,
//                 text: 'Second',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorPurple,
//                 text: 'Third',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorGreen,
//                 text: 'Fourth',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 18,
//               ),
//             ],
//           ),
//           const SizedBox(
//             width: 28,
//           ),
//         ],
//       ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(4, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 25.0 : 16.0;
//       final radius = isTouched ? 60.0 : 50.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: AppColors.contentColorBlue,
//             value: 40,
//             title: '40%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColors.mainTextColor1,
//               shadows: shadows,
//             ),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: AppColors.contentColorYellow,
//             value: 30,
//             title: '30%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColors.mainTextColor1,
//               shadows: shadows,
//             ),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: AppColors.contentColorPurple,
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColors.mainTextColor1,
//               shadows: shadows,
//             ),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: AppColors.contentColorGreen,
//             value: 15,
//             title: '15%',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: AppColors.mainTextColor1,
//               shadows: shadows,
//             ),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
// }

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class LineChartSample2 extends StatefulWidget {
//   const LineChartSample2({Key? key}) : super(key: key);

//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }

// class _LineChartSample2State extends State<LineChartSample2> {
//   bool showAvg = false;

//   @override
//   Widget build(BuildContext context) {
//     return LineChartWidget(showAvg: showAvg, onToggleAvg: toggleAvg);
//   }

//   void toggleAvg() {
//     setState(() {
//       showAvg = !showAvg;
//     });
//   }
// }

// class LineChartWidget extends StatelessWidget {
//   final bool showAvg;
//   final VoidCallback onToggleAvg;

//   const LineChartWidget({
//     required this.showAvg,
//     required this.onToggleAvg,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Expanded(
//         child: Stack(
//           children: <Widget>[
//             AspectRatio(
//               aspectRatio: 1.70,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   right: 18,
//                   left: 12,
//                   top: 24,
//                   bottom: 12,
//                 ),
//                 child: LineChart(
//                   showAvg ? _avgData() : _mainData(),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 60,
//               height: 34,
//               child: TextButton(
//                 onPressed: onToggleAvg,
//                 child: Text(
//                   'avg',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color:
//                         showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ]);
//   }

  // ... (other methods remain the same)

  // LineChartData _mainData() {
  //   // ... (same as in _LineChartSample2State)
  // }

  // LineChartData _avgData() {
  //   // ... (same as in _LineChartSample2State)
  // }
// }




  // return Column(
  //     children: [
  //       // First Half: Line Chart
  //      Expanded(
  //         child: Stack(
  //           children: <Widget>[
  //             // Title
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Positioned(
  //               top: 8,
  //               left: 12,
  //               child: Text(
  //                 'Line Bar Chart',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //             // Wrap your LineChart in a Container with the desired height
  //             Container(
  //               height: MediaQuery.of(context).size.height / 2,
  //               child: AspectRatio(
  //                 aspectRatio: 1.70,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                     right: 18,
  //                     left: 12,
  //                     top: 24,
  //                     bottom: 12,
  //                   ),
  //                   child: Consumer<LineChartViewModel>(
  //                     builder: (context, model, child) {
  //                       return LineChart(model.mainData());
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       // Second Half: Pie Chart
  //       Expanded(
  //         child: PieChartSample2(),
  //       ),
  //     ],
  //   );