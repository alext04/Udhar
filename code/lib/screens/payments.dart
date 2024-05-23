import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:udhar/utils/app_bar.dart';
import 'package:udhar/widgets/home_page/balance_card.dart';

// serves as the UI to handle user-triggered payments within the app. It integrates with Razorpay for processing payments and updates transaction records in Firebase Firestore.
class PaymentForm extends StatefulWidget {
  final User user;
  const PaymentForm({super.key, required this.user});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

// Manages the state for PaymentForm, handling user interactions, payment processing, and updates to Firestore based on payment outcomes
class _PaymentFormState extends State<PaymentForm> {
  double totalBalance = 0.0;
  String name = '';

  Razorpay? _razorpay;

// Handles successful payments by showing a success message and updating Firestore databases 
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "Payment SUCCESS : ${response.paymentId} ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Color(0xff272727),
        textColor: Colors.green,
        fontSize: 16.0);

    final uid = widget.user.uid;

    final transactionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Transactions')
        .doc();

    final transactionData = {
      'paymentID': response.paymentId.toString(),
      'amount': totalBalance.toString(),
      'dateTime':
          DateTime.now().toString(), // Assuming dateTime is a DateTime object
    };

    await transactionRef.set(transactionData);

    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Cards');
    final batch = FirebaseFirestore.instance.batch();
    final cardSnapshot = await cardRef.get();
    for (var doc in cardSnapshot.docs) {
      batch.update(doc.reference, {'balance': '0'});
    }

    await batch.commit();

    final batch2 = FirebaseFirestore.instance.batch();

    final rentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Rents');
    final rentSnapshot = await rentRef.get();
    for (var doc in rentSnapshot.docs) {
      batch2.update(doc.reference, {'balance': '0'});
    }

    await batch2.commit();

    setState(() {
      totalBalance = 0.00;
    });
  }

// Catches and alerts the user to any issues during the payment process.
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment FAILED : ${response.code} , ${response.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Color(0xff272727),
        textColor: Colors.red,
        fontSize: 16.0);
  }

// Handles payments made through external wallets like Google Pay, Paytm, etc.
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "Payment SUCCESS : ${response.walletName} ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Color(0xff272727),
        textColor: Colors.blue,
        fontSize: 16.0);
  }

// Retrieves the latest balance information from Firestore, adding up totals from cards and rents to display on the UI..
  Future<void> _fetchBalance() async {
    final uid = widget.user.uid;
    final cardref2 =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

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
      print(totalBalance * 100);
      name = cardref2['name'];
    });
  }

// Prepares and opens the Razorpay payment gateway with appropriate options such as total amount, user contact information, and a callback to handle the payment response.
  void makePayment() async {
    _fetchBalance();

    var options = {
      'key': "rzp_test_BxTVf62szh3KhA",
      'amount': totalBalance * 100,
      'name': name,
      'description': "",
      'prefill': {
        'contact': "+917045857846",
        'email': "hemangjain112@gmail.com"
      },
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchBalance();
  }

// Ui interface for the user to interact
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(
        user: widget.user,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            BalanceCard(user: widget.user),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                makePayment();
              },
              child: Text("PayNow"),
            ),
          ],
        ),
      ),
    );
  }
}
