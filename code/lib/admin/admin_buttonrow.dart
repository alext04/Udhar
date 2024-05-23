import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:udhar/admin/admin_notifications.dart';
import 'package:udhar/admin/admin_payment.dart';
import 'package:udhar/admin/view_users.dart';


import 'view_users.dart';

// defination for the action button row
class IconActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color textColor;
  final Color pressedColor;

  IconActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor = Colors.blue,
    this.textColor = Colors.white,
    this.pressedColor = Colors.red,
  });

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: iconColor,
            size: 30, // Adjust size as needed
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}

// class that is called to show the quick links for all the pages in the home screen
class ActionButtonRow extends StatelessWidget {
  final Color iconColor =
      Color.fromARGB(255, 255, 255, 255); // Example preset icon color
  final Color textColor = Colors.white; // Example preset text color
  final Color pressedColor =
      Colors.deepPurpleAccent;

  ActionButtonRow({Key? key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconActionButton(
            icon: Icons.supervised_user_circle_outlined,
            label: 'View Users',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ViewUserPage()),
                );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          IconActionButton(
            icon: Icons.credit_card,
            label: 'Payment',
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentsPage()),
                      );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          IconActionButton(
            icon: Icons.home_work,
            label: 'Notification',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminNotifications()),
                );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          
        ],
      ),
    );
  }
}
