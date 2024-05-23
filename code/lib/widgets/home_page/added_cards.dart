import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/screens/display_cards.dart';

String obscureCreditCardNumber(String creditCardNumber) {
  if (creditCardNumber.isEmpty) {
    return '';
  }

  List<String> parts = creditCardNumber.split(' ');
  final t = parts[3];
  final s = parts[0];
  return "$s **** **** $t";
}

class CardsAdded extends StatelessWidget {
  final User user;

  const CardsAdded({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 10.0, bottom: 8.0),
          child: Text(
            'Added Cards',
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
            .collection('Cards')
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
          final cards = snapshot.data!.docs;
          final List<CreditCard> creditCards = [];
          for (var card in cards) {
            final cardData = card.data() as Map<String, dynamic>;
            final curr = CreditCard(
              number: cardData['cardNumber'] ?? 'N/A',
              expiryDate: cardData['expiryDate'] ?? 'N/A',
              cvvCode: cardData['cvvCode'] ?? 'N/A',
              cardHolderName: cardData['cardHolderName'] ?? 'N/A',
              balance: cardData['balance'] ?? 'N/A',
              dueDate: cardData['dueDate'] ?? 'N/A',
            );
            creditCards.add(curr);
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
                    children: creditCards
                        .map((card) => TransactionTile(
                              company: card.number.toString(),
                              date: card.dueDate.toString(),
                              amount: card.balance.toString(),
                            ))
                        .toList()
                    //  <Widget>[
                    //   TransactionTile(
                    //     company: 'MasterCard XXXX',
                    //     date: 'May 24, 2022',
                    //     amount: '-₹ 103.56',
                    //   ),
                    //   TransactionTile(
                    //     company: 'Rent',
                    //     date: 'May 24, 2022',
                    //     amount: '-₹ 250.56',
                    //   ),
                    //   TransactionTile(
                    //     company: 'Rupay XXXX',
                    //     date: 'May 24, 2022',
                    //     amount: '-₹ 103.56',
                    //   ),
                    //   TransactionTile(
                    //     company: 'Visa XXXX',
                    //     date: 'May 24, 2022',
                    //     amount: '-₹ 103.56',
                    //   ),
                    //   // Add more TransactionTiles as needed
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
    final no = obscureCreditCardNumber(company);
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
          no,
          style: TextStyle(
              color: Colors.white), // Replace with your preferred text color
        ),
        subtitle: Text(
          "Due Date: $date",
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
                text: "₹ $amount", // Remove the '-' sign
                style: TextStyle(
                    color: Color.fromARGB(255, 247, 17, 4),
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
