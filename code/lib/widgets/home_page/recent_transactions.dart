import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String name;
  final String amount;
  final String date;
  

  const Transaction({
    required this.name,
    required this.date,
    required this.amount,
  });
}


class ModularHorizontalList extends StatelessWidget {
  final User user;

  const ModularHorizontalList({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 10.0, bottom: 8.0),
          child: Text(
            'RECENT PAYMENTS',
            style: TextStyle(
              color: Color.fromARGB(255, 146, 119, 226),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TransactionList(user: user),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  final User user;
  const TransactionList({Key? key, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Transactions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message
          }
          if (!snapshot.hasData) {
            return Text('No cards available'); // Show no cards message
          }
          final ts = snapshot.data!.docs;
          final List<Transaction> transactions = [];
          for (var t in ts) {
            final cardData = t.data() as Map<String, dynamic>;
          final curr=  Transaction(
              name: cardData['paymentID'] ?? 'N/A',
              date: cardData['dateTime'] ?? 'N/A',
              amount: cardData['amount'] ?? 'N/A',
            );
            transactions.add(curr);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 4.0,
                  top: 2.0,
                  right: 4.0,
                  bottom: 8.0,
                ),
              ),
              Container(
                height:
                    100.0, // Set the height to match a single transaction tile
                child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: transactions
                        .map((card) => TransactionTile(
                      company: card.name.toString(),
                      date: card.date.toString(),
                      amount: card.amount.toString(),
                    ))
                        .toList()
                    // <Widget>[

                    
                    // TransactionTile(
                    //   company: 'Rent',
                    //   date: 'May 24, 2022',
                    //   amount: '-₹ 250.56',
                    // ),
                    // TransactionTile(
                    //   company: 'Rupay XXXX',
                    //   date: 'May 24, 2022',
                    //   amount: '-₹ 103.56',
                    // ),
                    // TransactionTile(
                    //   company: 'Visa XXXX',
                    //   date: 'May 24, 2022',
                    //   amount: '-₹ 103.56',
                    // ),
                    // Add more TransactionTiles as needed
                    // ],
                    ),
              ),
            ],
          );
        });
  }
}

class TransactionTile extends StatelessWidget {
  final String company;
  final String date;
  final String amount;

  TransactionTile(
      {required this.company, required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 5.0), // Space between cells
      decoration: BoxDecoration(
        color: Color.fromARGB(
            255, 42, 39, 76), // Replace with your preferred cell color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 8), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 0.0), // Padding inside the cell
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            company[0], // Placeholder for company logo
            style: TextStyle(color: Colors.black), // Logo/text color
          ),
        ),
        title: Text(
          company,
          style: TextStyle(
              color: Colors.white), // Replace with your preferred text color
        ),
        subtitle: Text(
          "Date : $date",
          style: TextStyle(
              color:
                  Colors.white70), // Replace with your preferred subtitle color
        ),
        trailing: RichText(
          text: TextSpan(
            children: [
              // WidgetSpan(
              //   child: Icon(Icons.currency_rupee, size: 15.0, color: Colors.redAccent),
              // ),
              TextSpan(
                text: "₹ ${amount.toString()}", // Remove the '-' sign
                style: TextStyle(
                    color: const Color.fromARGB(255, 82, 255, 108),
                    fontSize:
                        16.0), // Replace with your preferred amount color and font size
              ),
            ],
          ),
        ),
      ),
    );
  }
}
