// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:udhar/admin/admin_creds.dart';
import 'package:udhar/admin/admin_home.dart';
import 'package:udhar/admin/admin_tmp.dart';
import 'package:udhar/constants/colors.dart';
import 'package:udhar/screens/add_card.dart';
import 'package:udhar/screens/display_cards.dart';
import 'package:udhar/screens/forgot_password.dart';
import 'package:udhar/screens/home_page.dart';
import 'package:udhar/screens/home_screen.dart';
import 'package:udhar/screens/signup_screen.dart';
import 'package:udhar/screens/rent_page.dart';

// Manages the login process for both regular users and administrators.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Manages the state of the LoginScreen, including text controllers and boolean states for form control visibility (password visibility).
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecured = true;
  String? emailError;
  String? passwordError;

  // Provides immediate feedback on input validity for email via dynamic state updates and form submissions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'UDHAR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 6, 4, 81),
      ),
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: emailController,
                          onChanged: (value) {
                            setState(() {
                              emailError = isValidEmail(value)
                                  ? null
                                  : 'Please enter a valid email';
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.direct_right,
                              color: TColors.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email",
                            errorText: emailError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: passwordController,
                          onChanged: (value) {
                            setState(() {
                              passwordError = value.isEmpty
                                  ? 'Please enter your password'
                                  : null;
                            });
                          },
                          obscureText: isSecured,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Iconsax.password_check,
                              color: TColors.primary,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSecured = !isSecured;
                                  });
                                },
                                icon: isSecured
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Password",
                            errorText: passwordError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill input'),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 94, 0, 202),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(
                                title: 'SIGN UP',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the forgot password screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Checks for admin credentials. If not admin, attempts Firebase sign-in and navigates to the appropriate user home page.
  Future<void> login() async {
    if (emailController.text == AdminCredentials.email) {
      if (passwordController.text == AdminCredentials.password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          ),
        );
      } else {
        // Handles Firebase authentication exceptions by categorizing them (e.g., invalid credentials) and displaying appropriate user-friendly messages.

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Error"),
              content: Text("Incorrect Email or Password. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Navigate to HomeScreen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: userCredential.user!),
            // builder: (context) => HomePage(),
            // builder: (context) => AddCards(user: userCredential.user!),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'invalid-credential') {
          errorMessage = 'Incorrect Email or Password. Please try again.';
        } else {
          errorMessage = 'An error occurred : ${e.code} ';
        }
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Error"),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error during login: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Error"),
              content: Text("An error occurred: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Validates email formats using regular expressions to ensure compliance with standard email formatting before attempting a login.
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
