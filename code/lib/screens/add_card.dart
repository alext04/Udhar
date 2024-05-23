import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:udhar/screens/display_cards.dart';
import '../utils/app_bar.dart';

// handles adding credit card details into a Firestore database and links the card data to the authenticated user..
class AddCards extends StatefulWidget {
  const AddCards({super.key, required this.user});
  final User user;
  @override
  State<AddCards> createState() => _AddCardsState();
}

// contains UI elements and logic to handle user interactions like entering card details and saving them to Firestore.
class _AddCardsState extends State<AddCards> {
  final Map<String, dynamic> cardData = {
    'cardNumber': '',
    'expiryDate': '',
    'cardHolderName': '',
    'cvvCode': '',
    'balance': '1000',
    'dueDate': '14/3/24'
  };
  bool isCvvFocused = true;
  bool useGlassMorphism = true;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // display the card's information and provide an interface for the user to input or edit card details.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 15, 17, 22),
        appBar: CustomAppBar(user: widget.user),
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext build) {
            return Center(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.user.uid),
                    CreditCardWidget(
                        enableFloatingCard: useFloatingAnimation,
                        cardNumber: cardData['cardNumber'],
                        expiryDate: cardData['expiryDate'],
                        cardHolderName: cardData['cardHolderName'],
                        cvvCode: cardData['cvvCode'],
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardBgColor: Color.fromARGB(255, 163, 0, 212),
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {}),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CreditCardForm(
                              formKey: formKey,
                              cardNumber: cardData['cardNumber'],
                              cardHolderName: cardData['cardHolderName'],
                              expiryDate: cardData['expiryDate'],
                              cvvCode: cardData['cvvCode'],
                              obscureCvv: true,
                              obscureNumber: true,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              inputConfiguration: const InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Number',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  hintStyle: TextStyle(),
                                  labelText: 'Card Holder',
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      // Show card button
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 0, 3, 74),
                              Color.fromARGB(255, 0, 6, 166),
                              Color.fromARGB(255, 37, 42, 172),
                              Color.fromARGB(255, 0, 6, 166),
                              Color.fromARGB(255, 0, 3, 74),
                            ],
                            begin: Alignment(-1, -4),
                            end: Alignment(1, 4),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Show Card',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                    ),
                    // Validate card button
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: _onValidate,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 0, 3, 74),
                              Color.fromARGB(255, 0, 6, 166),
                              Color.fromARGB(255, 37, 42, 172),
                              Color.fromARGB(255, 0, 6, 166),
                              Color.fromARGB(255, 0, 3, 74),
                            ],
                            begin: Alignment(-1, -4),
                            end: Alignment(1, 4),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: const Text(
                          'Validate',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      // print('valid!');
      var val = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('Cards');

      await val.add(cardData);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayCards(user: widget.user)),
      );
    } else {
      print('invalid!');
    }
  }

  // effects for card UI
  Glassmorphism? _getGlassmorphismConfig() {
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient);
  }

  // updating Credit Card info and displaying it on the UI
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardData['cardNumber'] = creditCardModel.cardNumber;
    cardData['expiryDate'] = creditCardModel.expiryDate;
    cardData['cardHolderName'] = creditCardModel.cardHolderName;
    cardData['cvvCode'] = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
  }
}
