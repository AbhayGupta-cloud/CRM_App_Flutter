import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/View/app_colors.dart';

class PieChartViewModel extends ChangeNotifier {
  List<PieChartSectionData> _sections = [];

  List<PieChartSectionData> get sections => _sections;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> pieChartData = {};
  Future<void> fetchPieChartData(String currentUserUID) async {
    try {
      // Query Firestore for leads for the current user
      final querySnapshot = await _firestore
          .collection('leads')
          .where('uid', isEqualTo: currentUserUID)
          .get();
      //process the querySnapshot to prepare piechartdata
      pieChartData = processPieChartData(querySnapshot);
      //Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error fetching pie chart data: $e");
    }
  }

  Map<String, int> processPieChartData(QuerySnapshot querySnapshot) {
    //Process Firestore data to create pie chart data
    //Example:
    final data = Map<String, int>();
    querySnapshot.docs.forEach((doc) {
      final status = doc['status'] as String;
      data[status] = data.containsKey(status) ? data[status]! + 1 : 1;
    });
    return data;
  }
  // Import the dart:math library

// ... (your other imports)

  Future<List<PieChartSectionData>> showingSections() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final String currentUserUid = user.uid;
    final List<PieChartSectionData> sections = [];
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('leads')
        .where('uid', isEqualTo: currentUserUid)
        .get();
    final leadStatusCounts = <String, int>{};

    snapshot.docs.forEach((doc) {
      final status = doc['status'] as String;
      leadStatusCounts[status] = (leadStatusCounts[status] ?? 0) + 1;
    });

    final totalLeads = snapshot.size.toDouble();

    if (totalLeads != 0) {
      final List<PieChartSectionData> newSections =
          leadStatusCounts.entries.map((entry) {
        final status = entry.key;
        final count = entry.value;
        final percentage = ((count / totalLeads) * 100).ceil(); // Use ceil here
        print(percentage);
        return PieChartSectionData(
          color: _getColorForStatus(status),
          value: percentage.toDouble(), // Convert percentage to double
          title: '$percentage%',
          radius: 50.0,
          titleStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        );
      }).toList();
      print(newSections);
      sections.addAll(newSections);
    }
    return sections;
  }

  Color _getColorForStatus(String status) {
    // Define colors for different lead statuses
    if (status == 'New') {
      return AppColors.contentColorBlue;
    } else if (status == 'In Progress') {
      return AppColors.contentColorYellow;
    } else if (status == 'Contacted') {
      return AppColors.contentColorGreen;
    } else {
      return AppColors.contentColorPurple;
    }
  }
}
