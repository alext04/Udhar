import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';


// widget designed to help users reset their passwords if they have forgotten them
class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();


  // Utilizes a TextEditingController named emailController to manage the text input for the user's email address.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password' , textAlign: TextAlign.center,style: TextStyle(color: Colors.white , fontWeight: FontWeight.w600),),
        backgroundColor: Color.fromRGBO(0, 162, 197, 0.7),
      ),
      backgroundColor: Color(0xFF010029),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right , color:Color.fromARGB(255, 94, 0, 202) ,),
                labelText: 'Enter your email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 94, 0, 202),
              ),
              child: Text('Send Reset Email' , style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  // Integrates with Firebase Authentication's sendPasswordResetEmail method to handle sending a password reset email to the provided email address.
  // Handles the logic to send a password reset email using Firebase Authentication.
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent!'),
        ),
      );
      // Navigate back to the login screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email: $e'),
        ),
      );
    }
  }
}