import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:udhar/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_bar.dart';

// holds properties for a credit card such as number, expiry date, card holder name, CVV, balance, and due date.
class CreditCard {
  final String number;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String balance;
  final String dueDate;

  const CreditCard({
    required this.number,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.balance,
    required this.dueDate,
  });
}

// that manages the display of individual credit card details and contains logic to handle toggling of autopay settings for a credit card.
class CreditCardItem extends StatefulWidget {
  final CreditCard card;

  const CreditCardItem({required this.card});

  @override
  State<CreditCardItem> createState() => _CreditCardItemState();
}

// Handles the display layout, including balance, due date, and a toggle switch for enabling autopay.
class _CreditCardItemState extends State<CreditCardItem> {
  bool _isAutopayEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: THelper.screenWidth(),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              cardNumber: widget.card.number,
              expiryDate: widget.card.expiryDate,
              cardHolderName: widget.card.cardHolderName,
              cvvCode: widget.card.cvvCode,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              showBackView: false,
              onCreditCardWidgetChange: (brand) {},
              cardBgColor: Color.fromARGB(255, 163, 0, 212),
              enableFloatingCard: true,
            ),
            // Balance and due date
            SizedBox(height: 20),
            _buildRoundedBox(
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Balance:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.0, color: Colors.white)),
                  SizedBox(width: THelper.screenWidth() * 0.5),
                  Text(
                    '\$${widget.card.balance.toString()}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ],
              ),
            ),
            _buildRoundedBox(
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Due Date:',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  SizedBox(width: THelper.screenWidth() * 0.5),
                  Text(
                    widget.card.dueDate,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            // Autopay toggle button
            _buildRoundedBox(
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Autopay:',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  SizedBox(width: THelper.screenWidth() * 0.5),
                  Switch(
                    value: _isAutopayEnabled,
                    onChanged: (value) =>
                        setState(() => _isAutopayEnabled = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // create boxes with rounded corners and shadows for containing text and switches.
  Widget _buildRoundedBox({required Widget child}) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 6, 4, 81),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Glassmorphism? _getGlassmorphismConfig() {
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(5), Colors.grey.withAlpha(5)],
      stops: const <double>[0.3, 0],
    );

    return Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient);
  }
}

// listens for real-time updates from Firestore about credit cards associated with the user.
class DisplayCards extends StatelessWidget {
  final User user;

  const DisplayCards({Key? key, required this.user}) : super(key: key);

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
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No cards available');
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

        return Scaffold(
          backgroundColor: Color.fromARGB(255, 15, 17, 22),
          appBar: CustomAppBar(user: user),
          // appBar: AppBar(
          //   title: Text('Credit Cards'),
          // ),
          body: SingleChildScrollView(
            child: Column(children: [
              CarouselSlider(
                items: creditCards
                    .map((card) => CreditCardItem(card: card))
                    .toList(),
                options: CarouselOptions(
                  padEnds: true,
                  viewportFraction: 1,
                  aspectRatio: 0.7,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.blue, // Background color
                        // onPrimary: Colors.white, // Text color
                        backgroundColor: Color.fromARGB(255, 0, 3, 74),
                        
                        elevation: 3, // Shadow intensity
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Button padding
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 19, // Text size
                            fontWeight: FontWeight.bold,
                            color: Colors.white // Text weight
                            ),
                      ))), // => Get.to(()=> const BottomNavigation()
            ]),
          ),
        );
      },
    );
  }
}
