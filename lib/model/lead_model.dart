import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/annotations.dart';

class Lead {
  final String id;
  final String company;
  final String firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? notes;
  final String? status;
  final String uid;
  final Timestamp createdAt; // Add this field for the createdAt timestamp
  Lead(
      {required this.id,
      required this.company,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.notes,
      required this.status,
      required this.uid,
      required this.createdAt
      // required List<dynamic> interactions,
      // required List<LeadCategory> categories,
      });
  factory Lead.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lead(
      id: doc.id,
      uid: data['uid'], // Replace 'userId' with the actual field name
      company: data['company'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phone: data['phone'],
      notes: data['notes'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }
}

class Interaction {
  final String? type;
  final String? content;
  final DateTime? timestamp;
  Interaction({
    required this.type,
    required this.content,
    required this.timestamp,
  });
}

class LeadCategory {
  final String? type;
  final String? value;

  LeadCategory({
    required this.type,
    required this.value,
  });
}
