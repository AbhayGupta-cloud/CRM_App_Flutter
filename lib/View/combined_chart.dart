import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/View/app_colors.dart';
import 'package:login_signup_page/ViewModel/pie_chart_view_model.dart';
import 'package:login_signup_page/chartFunctionalComponents/line_chart_function.dart';
import 'package:login_signup_page/widgets/indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PieChartViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyChartPage(),
    );
  }
}

class MyChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserUID = getCurrentUserUid();
    Provider.of<PieChartViewModel>(context, listen: false)
        .fetchPieChartData(currentUserUID);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: ChartWidget(),
    );
  }
}

class ChartWidget extends StatefulWidget {
  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Future<List<SalesData>> _getFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    // Get the current user
    final user = auth.currentUser;
    if (user == null) {
      // Handle the case when no user is logged in
      return [];
    }

    final currentDate = DateTime.now();
    final currentYear = currentDate.year;

    final querySnapshot = await firestore
        .collection('leads')
        .where('uid', isEqualTo: user.uid)
        .where('createdAt', isGreaterThanOrEqualTo: DateTime(currentYear))
        .get();

    final data = querySnapshot.docs.map((doc) {
      final createdAt = doc['createdAt'] as Timestamp;
      final month = _getMonthName(createdAt.toDate().month);
      return SalesData(month, 1); // Counting each lead as 1
    }).toList();

    // Group data by month and sum the counts
    final groupedData = Map<String, double>();
    data.forEach((item) {
      if (groupedData.containsKey(item.year)) {
        groupedData[item.year] = groupedData[item.year]! + 1;
      } else {
        groupedData[item.year] = 1;
      }
    });

    return groupedData.entries
        .map((entry) => SalesData(entry.key, entry.value))
        .toList();
  }

  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUNE';
      case 7:
        return 'JULY';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color of the whole screen
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<SalesData>>(
              future: _getFirestoreData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final chartData = snapshot.data ?? [];
                  return SfCartesianChart(
                    plotAreaBackgroundColor:
                        Colors.white, // Set the background color of the chart
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Monthly Leads Analysis'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  );
                }
              },
            ),
            Expanded(
              child: Container(
                // Your content below the chart
                child: PieChartSample2(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

LineChartData avgData(List<FlSpot> lineChartData) {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  // Sort lineChartData based on x-values
  lineChartData.sort((a, b) => a.x.compareTo(b.x));
  print('Sorted lineChartData avg function: $lineChartData');

  return LineChartData(
    minX: lineChartData.isNotEmpty ? lineChartData.first.x : 0,
    maxX: lineChartData.isNotEmpty ? lineChartData.last.x : 0,
    lineBarsData: [
      LineChartBarData(
        spots: lineChartData,
        isCurved: true,
        gradient: LinearGradient(
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
          ],
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!
                  .withOpacity(0.1),
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!
                  .withOpacity(0.1),
            ],
          ),
        ),
      ),
    ],
  );
}

LineChartData mainData() {
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

class PieChartSample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            'Lead Status Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FutureBuilder<List<PieChartSectionData>>(
                    future: Provider.of<PieChartViewModel>(context)
                        .showingSections(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<PieChartSectionData> sections =
                            snapshot.data ?? [];
                        return PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                // ... (unchanged code)
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sections: sections,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Indicator(
                    color: AppColors.contentColorBlue,
                    text: 'New Lead',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorYellow,
                    text: 'In Progress Lead',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorPurple,
                    text: 'Others',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: AppColors.contentColorGreen,
                    text: 'Contacted Lead',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getCurrentUserUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return '';
  }
}
























// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:login_signup_page/View/app_colors.dart';
// import 'package:login_signup_page/ViewModel/line_chart_view_model.dart';
// import 'package:login_signup_page/ViewModel/pie_chart_view_model.dart';
// import 'package:login_signup_page/chartFunctionalComponents/line_chart_function.dart';
// import 'package:login_signup_page/widgets/indicator.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => LineChartViewModel()),
//         ChangeNotifierProvider(create: (_) => PieChartViewModel()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyChartPage(),
//     );
//   }
// }

// class MyChartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Fetch chart data when the page is built
//     final currentUserUID = getCurrentUserUid();
//     Provider.of<LineChartViewModel>(context, listen: false)
//         .fetchLineChartData(currentUserUID);
//     Provider.of<PieChartViewModel>(context, listen: false)
//         .fetchPieChartData(currentUserUID);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Combined Line and Pie Charts'),
//       ),
//       body: ChartScreen(),
//     );
//   }
//   void toggleAvg() {
//     setState(() {
//       showAvg = !showAvg;
//     });
//   }
// }

// class ChartScreen extends StatelessWidget {
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
//                   showAvg ? _avgData() : mainData(),
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
//        //Second Half Pie Chart
//     Expanded(
//       child: PieChartSample2(),
//     ),
//     ]);
//   }
// }

// LineChartData _avgData() {
//   return LineChartData(
//     lineTouchData: const LineTouchData(enabled: false),
//     gridData: FlGridData(
//       show: true,
//       drawHorizontalLine: true,
//       verticalInterval: 1,
//       horizontalInterval: 1,
//       getDrawingVerticalLine: (value) {
//         return const FlLine(
//           color: Color(0xff37434d),
//           strokeWidth: 1,
//         );
//       },
//       getDrawingHorizontalLine: (value) {
//         return const FlLine(
//           color: Color(0xff37434d),
//           strokeWidth: 1,
//         );
//       },
//     ),
//     titlesData: FlTitlesData(
//       show: true,
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           getTitlesWidget: bottomTitleWidgets,
//           interval: 1,
//         ),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: leftTitleWidgets,
//           reservedSize: 42,
//           interval: 1,
//         ),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//     ),
//     borderData: FlBorderData(
//       show: true,
//       border: Border.all(color: const Color(0xff37434d)),
//     ),
//     minX: 0,
//     maxX: 11,
//     minY: 0,
//     maxY: 6,
//     lineBarsData: [
//       LineChartBarData(
//         spots: const [
//           FlSpot(0, 3.44),
//           FlSpot(2.6, 3.44),
//           FlSpot(4.9, 3.44),
//           FlSpot(6.8, 3.44),
//           FlSpot(8, 3.44),
//           FlSpot(9.5, 3.44),
//           FlSpot(11, 3.44),
//         ],
//         isCurved: true,
//         gradient: LinearGradient(
//           colors: [
//             ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                 .lerp(0.2)!,
//             ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                 .lerp(0.2)!,
//           ],
//         ),
//         barWidth: 5,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!
//                   .withOpacity(0.1),
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!
//                   .withOpacity(0.1),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }

// LineChartData mainData() {
//   return LineChartData(
//     gridData: FlGridData(
//       show: true,
//       drawVerticalLine: true,
//       horizontalInterval: 1,
//       verticalInterval: 1,
//       getDrawingHorizontalLine: (value) {
//         return const FlLine(
//           color: AppColors.mainGridLineColor,
//           strokeWidth: 1,
//         );
//       },
//       getDrawingVerticalLine: (value) {
//         return const FlLine(
//           color: AppColors.mainGridLineColor,
//           strokeWidth: 1,
//         );
//       },
//     ),
//     titlesData: FlTitlesData(
//       show: true,
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           interval: 1,
//           getTitlesWidget: bottomTitleWidgets,
//         ),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTitlesWidget: leftTitleWidgets,
//           reservedSize: 42,
//         ),
//       ),
//     ),
//     borderData: FlBorderData(
//       show: true,
//       border: Border.all(color: const Color(0xff37434d)),
//     ),
//     minX: 0,
//     maxX: 11,
//     minY: 0,
//     maxY: 6,
//     lineBarsData: [
//       LineChartBarData(
//         spots: const [
//           FlSpot(0, 3),
//           FlSpot(2.6, 2),
//           FlSpot(4.9, 5),
//           FlSpot(6.8, 3.1),
//           FlSpot(8, 4),
//           FlSpot(9.5, 3),
//           FlSpot(11, 4),
//         ],
//         isCurved: true,
//         gradient: LinearGradient(
//           colors: gradientColors,
//         ),
//         barWidth: 5,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(
//           show: false,
//         ),
//         belowBarData: BarAreaData(
//           show: true,
//           gradient: LinearGradient(
//             colors:
//                 gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ),
//     ],
//   );
// }


// class PieChartSample2 extends StatefulWidget {
//   const PieChartSample2({Key? key});

//   @override
//   State<StatefulWidget> createState() => PieChart2State();
// }

// class PieChart2State extends State<PieChartSample2> {
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
//               child: FutureBuilder<List<PieChartSectionData>>(
//                 future:
//                     Provider.of<PieChartViewModel>(context).showingSections(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // If the Future is still loading, return a loading indicator or placeholder.
//                     return CircularProgressIndicator();
//                   } else if (snapshot.hasError) {
//                     // If there's an error, display an error message.
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     // If the Future is complete and successful, build the PieChart using the data.
//                     List<PieChartSectionData> sections = snapshot.data ?? [];
//                     return PieChart(
//                       PieChartData(
//                         pieTouchData: PieTouchData(
//                           touchCallback:
//                               (FlTouchEvent event, pieTouchResponse) {
//                             setState(() {
//                               if (!event.isInterestedForInteractions ||
//                                   pieTouchResponse == null ||
//                                   pieTouchResponse.touchedSection == null) {
//                                 touchedIndex = -1;
//                                 return;
//                               }
//                               touchedIndex = pieTouchResponse
//                                   .touchedSection!.touchedSectionIndex;
//                             });
//                           },
//                         ),
//                         borderData: FlBorderData(
//                           show: false,
//                         ),
//                         sections: sections,
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Indicator(
//                 color: AppColors.contentColorBlue,
//                 text: 'New Lead',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorYellow,
//                 text: 'In Progress Lead',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorPurple,
//                 text: 'Others',
//                 isSquare: true,
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Indicator(
//                 color: AppColors.contentColorGreen,
//                 text: 'Contacted Lead',
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
// }

// String getCurrentUserUid() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     return user.uid;
//   } else {
//     // Handle the case when there is no authenticated user.
//     // You might return null or an empty string, or handle it differently based on your app's requirements.
//     return '';
//   }
// }
