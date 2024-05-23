import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_buttonrow.dart';
import 'admin_appbar.dart';
import 'user_detailed.dart';


// pages to allow future implementation of alerts for admin
class AdminNotifications extends StatelessWidget {

  const AdminNotifications({Key? key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AdminAppBar(),
      
    );
  }
}





