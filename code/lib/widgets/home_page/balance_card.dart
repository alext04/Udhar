import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key? key, required this.user});
  final User user;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    final uid = widget.user.uid;
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Cards');
    final cardSnapshot = await cardRef.get();

    double cardTotal = 0.0;
    for (var doc in cardSnapshot.docs) {
      final cardData = doc.data();
      cardTotal += double.parse(
          cardData['balance']); // Assuming 'balance' is a number field
    }

    final rentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Rents');
    final rentSnapshot = await rentRef.get();

    double rentTotal = 0.0;
    for (var doc in rentSnapshot.docs) {
      final rentData = doc.data();
      rentTotal += double.parse(
          rentData['balance']); // Assuming 'amount' is a number field
    }

    setState(() {
      totalBalance = cardTotal + rentTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _fetchBalance();
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(80),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6E78F7), // Lighter purple
            Color(0xFF120142), // Darker purple
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            totalBalance.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Amount Due',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
