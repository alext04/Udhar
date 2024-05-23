
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:udhar/constants/colors.dart';
import 'package:udhar/utils/app_bar.dart';
import 'package:udhar/widgets/home_page/recent_transactions.dart';

class Transaction {
  String? id;
  String? date;
  String? amount;

  Transaction({required this.id, required this.date, required this.amount});
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, required this.user});
  final User user;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> transactions = [];
  List<Transaction> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  getUsers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('Transactions')
        .get();
    setState(() {
      transactions.clear();
      for (final document in querySnapshot.docs) {
        transactions.add(Transaction(
          id:document.data()["paymentID"],
          amount: document.data()["amount"],
          date:document.data()["dateTime"]
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    filteredUsers = transactions; // Initially filteredUsers is same as all users
  }

  void _filterUsers() {
    final searchQuery = searchController.text;
    List<Transaction> tmpList = [];
    if (searchQuery.isNotEmpty) {
      tmpList.addAll(transactions.where(
        (transaction) => transaction.id!.toLowerCase().contains(searchQuery.toLowerCase()),
      ));
    } else {
      tmpList = List<Transaction>.from(transactions);
    }
    setState(() {
      filteredUsers = tmpList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search by Transaction ID',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _filterUsers,
                  )
                ],
              ),
            ),
            Column(
              children: filteredUsers
                        .map((card) => TransactionTile(
                      company: card.id.toString(),
                      date: card.date.toString(),
                      amount: card.amount.toString(),
                    ))
                        .toList(),
            )
          ],
        ),
      ),
    );
  }
}
