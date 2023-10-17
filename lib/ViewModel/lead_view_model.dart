import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/model/lead_model.dart';

class LeadViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String leadsCollection =
      'leads'; // Replace with your actual collection name
  Future<void> addLead(
      BuildContext context,
      String uid,
      String company,
      String firstName,
      String lastName,
      String email,
      String phone,
      String notes) async {
    try {
      print('Adding lead: $company, $firstName, $lastName, $email, $phone');
      final leadData = {
        'uid': uid, //Include the user's uid in the lead data
        'company': company,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(), // Add a timestamp field
      };
      // await _firestore.collection('leads').add({
      //   'company': company,
      //   'firstName': firstName,
      //   'lastName': lastName,
      //   'email': email,
      //   'phone': phone,
      //   'notes': notes,
      //   'status': 'New',
      //   // 'interactions': [],
      //   // 'categories': [],
      // });
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('leads').add(leadData);
      print('Lead added successfully');
    } catch (e) {
      print('Error adding lead: $e');
    }
  }

  Future<void> updateLead(BuildContext context, Lead lead) async {
    try {
      final DocumentReference leadDocRef =
          _firestore.collection(leadsCollection).doc(lead.id);

      await leadDocRef.update({
        'email': lead.email,
        'firstName': lead.firstName,
        'lastName': lead.lastName,
        'status': lead.status,
        'phone': lead.phone,
        'notes': lead.notes
        // Add other fields you want to update here
      });

      print('Lead updated successfully');
      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lead updated successfully'),
          duration: Duration(seconds: 2), // Optional duration
          backgroundColor: Colors.green, // Optional color
        ),
      );
    } catch (e) {
      print('Error updating lead: $e');
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating lead: $e'),
          duration: Duration(seconds: 2), // Optional duration
          backgroundColor: Colors.red, // Optional color
        ),
      );

      throw e; // Rethrow the error for error handling, if needed
    }
  }

  Future<void> updateLeadStatus(String leadId, String newStatus) async {
    try {
      await _firestore
          .collection('leads')
          .doc(leadId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updatinng lead status: $e');
    }
  }

  Future<void> addInteraction(
      String leadId, String type, String content) async {
    try {
      final timestamp = Timestamp.now();
      await _firestore.collection('leads').doc(leadId).update({
        'interactions': FieldValue.arrayUnion([
          {
            'type': type,
            'content': content,
            'timestamp': timestamp,
          }
        ])
      });
    } catch (e) {
      print('Error adding interaction: $e');
    }
  }

  Future<List<Lead>> getLeadsForUser(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('leads')
          .where('uid',
              isEqualTo:
                  uid) // Replace 'userId' with the actual field name where you store the user's ID
          .get();

      final leads =
          querySnapshot.docs.map((doc) => Lead.fromSnapshot(doc)).toList();

      return leads;
    } catch (e) {
      // Handle errors here, e.g., display an error message
      print("Error fetching leads: $e");
      throw e;
    }
  }

  Future<void> addCategory(String leadId, String type, String value) async {
    try {
      await _firestore.collection('leads').doc(leadId).update({
        'categories': FieldValue.arrayUnion([
          {
            'type': type,
            'value': value,
          }
        ]),
      });
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> deleteLead(String leadId, BuildContext context) async {
    try {
      await _firestore.collection('leads').doc(leadId).delete();
      // Display a success message in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lead deleted successfully"),
        ),
      );
    } catch (e) {
      // Handle errors by displaying a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting lead: $e"),
        ),
      );
    }
  }

  Future<List<Lead>> getLeads() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('leads').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return Lead(
        id: doc.id,
        company: data['company'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        notes: data['notes'] ?? '',
        status: data['status'] ?? '',
        uid: data['uid'] ?? '',
        createdAt: data['createdAt'] ??
            Timestamp.now(), // Use Timestamp.now() as the default value
      );
    }).toList();
  }
}
