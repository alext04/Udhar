import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_bar.dart';

class NotificationPage extends StatelessWidget {
  final User user;

  const NotificationPage({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user:user),
      body: Column(
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
