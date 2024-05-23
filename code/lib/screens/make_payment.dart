import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_bar.dart';


// Serves as a scaffold for a payment interface, providing a structural template where specific payment-related functionalities can be implemented
class MakePayment extends StatelessWidget {
  final User user;

  const MakePayment({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user:user),
      body: Column(),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
