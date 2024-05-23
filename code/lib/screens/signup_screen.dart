import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:udhar/admin/admin_creds.dart';
import 'package:udhar/constants/colors.dart';
import 'package:udhar/screens/otp_verification_page.dart';
import 'login_screen.dart';


// user interface where new users can create an account by entering their personal details such as name, email, phone number, and password.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

// Manages the state and behavior of the SignUpScreen, including form validation, user input handling, and interaction with Firebase for registering new users.
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecured = true;
  String? nameError;
  String? emailError;
  String? phoneNumberError;
  String? passwordError;


// Ui interface for user interaction
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            _buildEmailPasswordForm(),
          ],
        ),
      ),
    );
  }

// Email and password form
  Widget _buildEmailPasswordForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      nameError =
                          value.isEmpty ? 'Please enter your name' : null;
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
                    labelText: "Name",
                    errorText: nameError,
                  ),
                ),
              ),
              // Add other form fields (email, password, etc.)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      emailError = !isValidEmail(value)
                          ? 'Please enter a valid email'
                          : null;
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
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: phoneNumberController,
                  onChanged: (value) {
                    setState(() {
                      phoneNumberError = value.length <= 9
                          ? 'Phone number must be at least 10 digits'
                          : null;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Iconsax.mobile,
                      color: TColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Phone Number",
                    errorText: phoneNumberError,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      passwordError = value.length < 6
                          ? 'Password must be at least 6 characters long'
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
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUpWithEmailAndPassword();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill input correctly'),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'SIGN UP',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        title: 'LOGIN',
                      ),
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Using RegExp for simple email validation
    // This regex matches most common email patterns but may not cover all edge cases
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

// ommunicates with Firebase's authentication system to attempt user registration with the provided email and password. It handles various outcomes like successful registration, errors due to weak passwords, or existing accounts.
  Future<void> signUpWithEmailAndPassword() async {
    if(emailController.text == AdminCredentials.email)
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
            content: Text("You are not allowed to sign up as an admin"),
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
      return;
    }
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Upload user details to Cloud Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Success"),
            content: Text("You have successfully signed up!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to OTP verification page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPVerification(
                        title: 'Verification', // Provide the title here
                        phoneNumber: phoneNumberController
                            .text, // Provide the phone number or retrieve it from somewhere
                      ),
                    ),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred : ${e.code}';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
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
      // Catch any other error
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Error"),
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
