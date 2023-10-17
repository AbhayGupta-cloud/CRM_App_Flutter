import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_page/View/combined_chart.dart';
import 'package:login_signup_page/View/lead_screen.dart';
import 'package:login_signup_page/View/lead_view.dart';
import 'package:login_signup_page/View/login_view.dart';
import 'package:login_signup_page/model/lead_model.dart';
import 'package:login_signup_page/model/user_model.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({super.key});
  final List<Lead> leads;

  HomeScreen({required this.leads});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data() ?? {});
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
      ),
      // Add a Drawer to the Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Add Lead'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      LeadList(), // Navigate to the lead management page
                ));
              },
            ),

            // Add more options for navigation here if needed
            ListTile(
                title: Text('View Leads'),
                onTap: () {
                  Navigator.of(context).pop(); //Close the drawer
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LeadListView(),
                  ));
                }),
            ListTile(
                title: Text('Show Analytics'),
                onTap: () {
                  Navigator.of(context).pop(); //Close the drawer
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyChartPage(),
                  ));
                }),
            // ListTile(
            //     title: Text('Monthly Leads Chart'),
            //     onTap: () {
            //       Navigator.of(context).pop(); //Close the drawer
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => ChartWidget(),
            //       ));
            //     }),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "${loggedInUser.firstName} ${loggedInUser.lastName}",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${loggedInUser.email}",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ActionChip(
                label: Text("Logout"),
                onPressed: () {
                  logout(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
