import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_signup_page/View/home_screen.dart';
import 'package:login_signup_page/View/registration_screen.dart';
import 'package:login_signup_page/ViewModel/lead_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key helpful in validating the email and password field
  bool _isLoading = false;
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  //editing controller
  //email controller
  final TextEditingController emailController = new TextEditingController();
  //password controller
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //regular expression for email validation
        if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9,-]+,[a-z]").hasMatch(value)) {
          return ("Please enter a valid email address");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(29, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //password field

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _isObscure,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter a Valid Password(Min. 6 Characters)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isObscure = !_isObscure; //Toggle password visibility
            });
          },
          child: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: _isObscure
                ? Colors.grey
                : Colors.blue, // Customize the icon color
          ),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: _isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //login function
  // void signIn(String email, String password) async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true; //show loader
  //     });
  //     await _auth
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((uid) => {
  //               Fluttertoast.showToast(msg: "Login Successful"),
  //               Navigator.of(context).pushReplacement(
  //                   MaterialPageRoute(builder: (context) => HomeScreen()))
  //             })
  //         .catchError((e) {
  //       Fluttertoast.showToast(msg: e!.message);
  //     }).whenComplete(() {
  //       setState(() {
  //         _isLoading = false; //Hide loader
  //       });
  //     });
  //   }
  // }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loader
      });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        final user = userCredential.user;
        final currentUserId = user?.uid; // Assuming user ID is stored in 'uid'

        if (currentUserId != null) {
          final leads = await LeadViewModel().getLeadsForUser(currentUserId);

          // Navigate to HomeScreen and pass the leads to it
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      leads: leads,
                    )),
          );

          Fluttertoast.showToast(msg: "Login Successful");
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      }).whenComplete(() {
        setState(() {
          _isLoading = false; // Hide loader
        });
      });
    }
  }
}
