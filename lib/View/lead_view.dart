import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_signup_page/View/edit_lead.dart';
import 'package:login_signup_page/ViewModel/lead_view_model.dart';
import 'package:login_signup_page/model/lead_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeadListView extends StatefulWidget {
  @override
  _LeadListViewState createState() => _LeadListViewState();
}

class _LeadListViewState extends State<LeadListView> {
  late LeadViewModel leadViewModel;
  TextEditingController searchController = TextEditingController();
  String selectedStatus = 'All'; // Default selection is 'All'
  List<Lead> allLeads = [];
  List<Lead> filteredLeads = [];
// hello world thi
  @override
  void initState() {
    super.initState();
    fetchLeads(); // Load leads data initially
    leadViewModel = Provider.of<LeadViewModel>(context, listen: false);
  }

  void fetchLeads() async {
    final leadViewModel = Provider.of<LeadViewModel>(context, listen: false);
    final leads = await leadViewModel.getLeads();

    final currentUserUid = getCurrentUserUid();
    final filteredLeads =
        leads.where((lead) => lead.uid == currentUserUid).toList();

    setState(() {
      allLeads = filteredLeads;
      this.filteredLeads = filteredLeads;
    });
  }

  String getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void filterLeads(String query) {
    final List<Lead> filteredList = allLeads.where((lead) {
      final leadText =
          '${lead.company} ${lead.firstName} ${lead.lastName}'.toLowerCase();
      return leadText.contains(query.toLowerCase());
    }).where((lead) {
      // Filter by status
      if (selectedStatus == 'All') {
        return true; // Show all leads
      } else {
        return lead.status == selectedStatus; // Show leads with selected status
      }
    }).toList();

    setState(() {
      filteredLeads = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterLeads(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search leads',
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                      filterLeads(searchController.text);
                    },
                    items: ['All', 'New', 'In Progress', 'Contacted']
                        .map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                final lead = filteredLeads[index];
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(8.0),
                  color: Color.fromARGB(255, 124, 162, 227),
                  child: ListTile(
                    title: Text(
                      lead.company,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name: ${lead.firstName}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Last Name: ${lead.lastName}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Email: ${lead.email}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Phone: ${lead.phone}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Notes: ${lead.notes}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Status: ${lead.status}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Created At: ${_formatTimestamp(lead.createdAt)}',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return EditLeadScreen(lead: lead);
                            }));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                      "Are you sure you want to delete this lead?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final leadIdToDelete = lead.id;
                                        await leadViewModel.deleteLead(
                                            leadIdToDelete, context);
                                        Navigator.of(context).pop();
                                        // Lead deleted successfully, you can add any post-deletion logic here
                                        // Refresh the current page (LeadListView) by pushing a new instance of it
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LeadListView(),
                                          ),
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    if (timestamp != null) {
      final dateTime = timestamp.toDate();
      final formattedDate = DateFormat.yMMMMd()
          .add_jm()
          .format(dateTime); // Adjust the format as needed
      return formattedDate;
    } else {
      return '';
    }
  }
}
