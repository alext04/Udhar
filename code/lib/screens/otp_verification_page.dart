import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

// initiates the OTP sending process when the widget is loaded and provides UI elements for the user to enter the received OTP.
class OTPVerification extends StatefulWidget {
  const OTPVerification({
    Key? key,
    required this.title,
    required this.phoneNumber,
  }) : super(key: key);

  final String title;
  final String phoneNumber;

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

//  Manages the dynamic state changes of the OTPVerification widget.
class _OTPVerificationState extends State<OTPVerification> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  String? otpError;
  String? verificationId;
  String currentOTP = '';

  final _duration = Duration(milliseconds: 500);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Call resendOTP function when the page loads
    resendOTP();
  }


  // Ui components
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
        backgroundColor: Color.fromRGBO(0, 162, 197, 0.7),
      ),
      backgroundColor: Color(0xFF010029),
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
                          controller: otpController,
                          onChanged: (value) {
                            // Cancel previous timer if any
                            _timer?.cancel();

                            // Create a new timer
                            _timer = Timer(_duration, () {
                              setState(() {
                                otpError = value.isEmpty
                                    ? 'Please enter the OTP'
                                    : null;
                                currentOTP = value;
                              });
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "OTP",
                            errorText: otpError,
                          ),
                        ),
                      ),
                      // Submits the entered OTP for verification.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                verifyOTP();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill input correctly'),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Verify OTP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Allows users to request a new OTP if the previous one didn't arrive or expired.
                      TextButton(
                        onPressed: () {
                          // Implement resend OTP functionality
                          resendOTP();
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(color: Colors.white),
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
                        // Provides a direct link back to the login screen
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // // Display current OTP, Verification ID, and Phone Number
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 8, right: 8),
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           'Phone Number: ${widget.phoneNumber}',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         Text(
                      //           'Current OTP: $currentOTP',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         Text(
                      //           'Current Verification ID: $verificationId',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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

  // links this credential with the user's existing account or signs the user in directly.
  Future<void> verifyOTP() async {
    try {
      if (verificationId == null) {
        throw FirebaseAuthException(
          code: 'invalid-verification-id',
          message: 'Verification ID is null. Please resend the OTP.',
        );
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text,
      );

      // Link the OTP credential with the existing email/password credential
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential)
          .catchError((error) {
        String errorMessage;
        if (error is FirebaseAuthException) {
          switch (error.code) {
            case "provider-already-linked":
              errorMessage =
                  "The provider has already been linked to the user.";
              break;
            case "invalid-credential":
              errorMessage = "The provider's credential is not valid.";
              break;
            case "credential-already-in-use":
              errorMessage =
                  "The account corresponding to the credential already exists, or is already linked to a Firebase User.";
              break;
            case "invalid-verification-code":
              errorMessage = "The verification code entered is invalid.";
              // Handle incorrect OTP here, for example:
              setState(() {
                otpError = 'Invalid OTP';
              });
              break;
            default:
              errorMessage = "Unknown error.";
          }
        } else {
          errorMessage = "An unknown error occurred: $error";
        }

        // Show alert dialog for the error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Verification Error"),
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
      });

      if (userCredential != null) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Account Linked"),
              content: Text(
                  "Your OTP account has been linked with your existing email/password account!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(title: 'LOGIN')),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Unknown error occurred: $e");
      // Show alert dialog for the unknown error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An unknown error occurred."),
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

  // Handles resending the OTP to the provided phone number, managing the entire lifecycle of the OTP including timeouts and failures.
  void resendOTP() async {
    try {
      // Add "+91" prefix if it's not already included
      String formattedPhoneNumber = widget.phoneNumber;
      if (!formattedPhoneNumber.startsWith('+91')) {
        formattedPhoneNumber = '+91${widget.phoneNumber}';
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(
              "Verification automatically completed with credential: $credential");
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Phone number verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print(
              "Verification code sent to the phone number: ${widget.phoneNumber}");
          print("Verification ID: $verificationId"); // Print verification ID
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      print("Error occurred during OTP resend: $e");
    }
  }
}
