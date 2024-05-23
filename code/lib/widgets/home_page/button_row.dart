import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:udhar/screens/display_cards.dart';
import 'package:udhar/screens/make_payment.dart';
import 'package:udhar/screens/payments.dart';
import 'package:udhar/screens/razorpay.dart';
import 'package:udhar/screens/rent_page.dart';
import 'package:udhar/screens/transactions.dart';
import 'package:udhar/screens/transactions.dart';

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

class ActionButtonRow extends StatelessWidget {
  final Color iconColor =
      Color.fromARGB(255, 255, 255, 255); // Example preset icon color
  final Color textColor = Colors.white; // Example preset text color
  final Color pressedColor =
      Colors.deepPurpleAccent; // Example preset pressed color
  final User user;

  ActionButtonRow({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconActionButton(
            icon: Icons.account_balance,
            label: 'Payments',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  PaymentForm(user:user)),
                );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          IconActionButton(
            icon: Icons.credit_card,
            label: 'Cards',
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DisplayCards(user:user)),
                      );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          IconActionButton(
            icon: Icons.home_work,
            label: 'Rent',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRent(user:user)),
                );
            },
            iconColor: iconColor,
            textColor: textColor,
            pressedColor: pressedColor,
          ),
          IconActionButton(
            icon: Icons.history,
            label: 'History',
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TransactionsPage(user:user)),
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
