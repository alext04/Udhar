import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_bar.dart';

// The purpose of the SettingsPage is to serve as the main interface where users can view and interact with various settings categories such as Profile, Notifications, Payment, Security, and more.
class SettingsPage extends StatelessWidget {
  final User user;

  const SettingsPage({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user: user),
      body: Center(
        child: Card(
          color: Color.fromRGBO(18, 0, 123, 0.69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(4),
          elevation: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                      color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold ), // Title text color
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: const [
                  SettingsItem(icon: Icons.person, title: 'Profile'),
                  SettingsItem(
                      icon: Icons.notifications, title: 'Notifications'),
                  SettingsItem(icon: Icons.info, title: 'Info'),
                  SettingsItem(icon: Icons.payment, title: 'Payment'),
                  SettingsItem(icon: Icons.security, title: 'Permissions'),
                  SettingsItem(icon: Icons.lock, title: 'Security'),
                  // Add more SettingsItems if needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This component is designed to be a reusable UI element within the SettingsPage, representing individual settings options.
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingsItem({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(0, 0, 53, 0.69),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.white), // Icon color
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize: 17)), // Text color
        trailing:
            const Icon(Icons.chevron_right, color: Colors.white), // Icon color
        onTap: () {
          // Handle the tap if necessary
        },
      ),
    );
  }
}
