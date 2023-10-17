import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/ViewModel/lead_view_model.dart';
import 'package:login_signup_page/model/lead_model.dart';

class EditLeadScreen extends StatefulWidget {
  final Lead lead;

  EditLeadScreen({required this.lead});

  @override
  _EditLeadScreenState createState() => _EditLeadScreenState();
}

class _EditLeadScreenState extends State<EditLeadScreen> {
  final LeadViewModel leadViewModel = LeadViewModel();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with lead data
    _firstNameController.text = widget.lead.firstName;
    _lastNameController.text = widget.lead.lastName!;
    _emailController.text = widget.lead.email;
    _phoneController.text = widget.lead.phone!;
    _notesController.text = widget.lead.notes!;
    _statusController.text = widget.lead.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lead'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_firstNameController, 'First Name'),
            _buildTextField(_lastNameController, 'Last Name'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_phoneController, 'Phone'),
            _buildTextField(_notesController, 'Notes'),
            _buildTextField(_statusController, 'Status'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the edited lead data and return to LeadListView
          _saveEditedLead(context, getCurrentUserUid());
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blueAccent, // Set the background color to blue
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _saveEditedLead(BuildContext context, String currentUserId) async {
    // Get the edited data from text controllers
    final DateTime currentTime = DateTime.now();
    final editedLead = Lead(
      id: widget.lead.id,
      company: widget.lead.company,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      notes: _notesController.text,
      status: _statusController.text,
      uid: currentUserId,
      createdAt: Timestamp(10, 12),
    );

    // Update the lead in your ViewModel or Firestore
    try {
      // Call the updateLead function from your ViewModel or Firestore
      await leadViewModel.updateLead(context, editedLead);

      // Return to the LeadListView screen
      Navigator.of(context).pop();
    } catch (e) {
      // Handle any errors here, if needed
      print('Error saving edited lead: $e');
      // You can also show an error snackbar here if desired
    }
    // leadViewModel.updateLead(editedLead);

    // Return to the LeadListView screen
    Navigator.of(context).pop();
  }

  String getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case when there is no authenticated user.
      // You might return null or an empty string, or handle it differently based on your app's requirements.
      return '';
    }
  }
}
