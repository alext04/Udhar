import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VerticalCardList(),
    );
  }
}

class VerticalCardList extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {'cardNumber': '**** **** **** 1111', 'amountDue': '1200', 'dueDate': 'Apr 20, 2024'},
    {'cardNumber': '**** **** **** 2222', 'amountDue': '350', 'dueDate': 'May 15, 2024'},
    {'cardNumber': '**** **** **** 3333', 'amountDue': '780', 'dueDate': 'Jun 10, 2024'},
    // Add more cards if needed
  ];

  // Calculate the total amount due
  String getTotalAmountDue() {
    return cards.fold<int>(
      0,
      (sum, card) => sum + int.parse(card['amountDue']!),
    ).toString();
  }

  Widget borderedText(String text) {
    return Stack(
      children: <Widget>[
        // Shadow-like effect
        Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1
              ..color = Colors.black,
          ),
        ),
        // Foreground text
        Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Store the total amount due
    final String totalAmountDue = getTotalAmountDue();

    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.green],
                ),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3, blurRadius: 10, offset: Offset(0, 3)),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                Text(
                    '\$$totalAmountDue',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  ],
              )
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                var card = cards[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[500]!,
                          Colors.grey[300]!,
                          Colors.grey[200]!,
                        ],
                        stops: [0.1, 0.3, 0.8, 1],
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        borderedText(card['cardNumber']!),
                        SizedBox(height: 20),
                        Text(
                          'Amount Due: \$${card['amountDue']}',
                          style: TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement your pay now action
                          },
                          child: Text('Pay Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Text(
                          'Due Date: ${card['dueDate']}',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
