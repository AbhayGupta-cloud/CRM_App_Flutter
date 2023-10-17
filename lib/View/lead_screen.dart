// views/lead_list.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_signup_page/View/lead_view.dart';
import 'package:login_signup_page/ViewModel/lead_view_model.dart';
import 'package:login_signup_page/model/lead_model.dart';
import 'package:provider/provider.dart';

class LeadList extends StatefulWidget {
  @override
  _LeadListState createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  @override
  Widget build(BuildContext context) {
    final leadViewModel = Provider.of<LeadViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Management'),
      ),
//       body: FutureBuilder<List<Lead>>(
//         future: leadViewModel.getLeads(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           final leads = snapshot.data ?? [];

//           return ListView.builder(
//             itemCount: leads.length,
//             itemBuilder: (context, index) {
//               final lead = leads[index];
//               String selectedStatus = 'New'; // Set the initial value

//               String currentUserUid =
//                   getCurrentUserUid(); // Replace with your function to get the user's UID
//               // Filter the list of leads based on the current user's UID
//               List<Lead> userLeads =
//                   leads.where((lead) => lead.uid == currentUserUid).toList();

//               // Create a set to store unique status values
//               Set<String> uniqueStatusSet = {};

// // Iterate through userLeads and add status values to the set
//               for (Lead lead in userLeads) {
//                 uniqueStatusSet.add(lead.status ?? 'Default Status');
//               }

// // Convert the set to a list for DropdownMenuItem items
//               List<DropdownMenuItem<String>> dropdownItems = uniqueStatusSet
//                   .map<DropdownMenuItem<String>>((String status) {
//                 return DropdownMenuItem<String>(
//                   value: status,
//                   child: Text(status ?? 'Default Status'),
//                 );
//               }).toList();
//               return ListTile(
//                 title: Text(lead.firstName),
//                 subtitle: Text(lead.email),
//                 // Assuming you have a list of leads and a function to get the current user's UID

// // Initialize selectedStatus and handleDropdownChange here

// // Now, use dropdownItems in your DropdownButton
//                 trailing: DropdownButton<String>(
//                   value: selectedStatus,
//                   items: dropdownItems,
//                   onChanged: (String? newStatus) {
//                     if (newStatus != null) {
//                       setState(() {
//                         selectedStatus = newStatus;
//                       });
//                       leadViewModel.updateLeadStatus(lead.id, newStatus);
//                     }
//                   },
//                 ),

//                 onTap: () {
//                   // Navigate to a detailed lead view page if needed.
//                 },
//               );
//             },
//           );
//         },
//       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final firstNameController = TextEditingController();
              final companyController = TextEditingController();
              final lastNameController = TextEditingController();
              final phoneController = TextEditingController();
              final emailController = TextEditingController();
              final notesController = TextEditingController();

              return AlertDialog(
                title: Text('Add Lead'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: companyController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Company *',
                          labelStyle: TextStyle(
                            color: Colors.red, // Set the label color to red
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      TextField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'First Name *',
                          labelStyle: TextStyle(
                            color: Colors.red, // Set the label color to red
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      TextField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email *',
                          labelStyle: TextStyle(
                            color: Colors.red, // Set the label color to red
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      TextField(
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Phone'),
                        style: TextStyle(color: Colors.blueAccent),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              10), //Limit input to 10 characters
                          FilteringTextInputFormatter
                              .digitsOnly //allow only digits
                        ],
                      ),
                      TextField(
                        controller: notesController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(labelText: 'Notes'),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final User? user = FirebaseAuth.instance.currentUser;
                      final uid = user?.uid;
                      final company = companyController.text.trim();
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();
                      final email = emailController.text.trim();
                      final phone = phoneController.text.trim();
                      final notes = notesController.text.trim();
                      if (company.isNotEmpty &&
                          firstName.isNotEmpty &&
                          email.isNotEmpty &&
                          uid != null) {
                        try {
                          //Attempt to add the lead
                          await leadViewModel.addLead(context, uid, company,
                              firstName, lastName, email, phone, notes);
                          //show success
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Lead added successfully'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ));
                          //close the dialog box
                          Navigator.of(context).pop();
                          // Navigate to the "View Leads" screen by pushing it onto the stack
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                LeadListView(), // Replace with your "View Leads" screen widget
                          ));
                        } catch (e) {
                          // If there's an error, show an error Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error adding lead: $e'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.blueAccent,
        ),
      ),
    );
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
