import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// To facilitate online payments using Razorpay, enabling users to initiate transactions directly from the app with just a few taps.
class RazorpayPage extends StatefulWidget {
  const RazorpayPage({super.key});

  @override
  State<RazorpayPage> createState() => _RazorpayPageState();
}

// state management class
class _RazorpayPageState extends State<RazorpayPage> {
  Razorpay? _razorpay;


// riggered when a payment is successfully processed. Displays a success message using Fluttertoast, 
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment SUCCESS : ${response.paymentId} ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Color(0xff272727),
        textColor: Colors.green,
        fontSize: 16.0);
  }

// Shows an error message detailing why the payment failed, which helps in diagnosing issues and informing the user of the problem.
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


// Handles scenarios where a payment is processed through an external wallet 
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
// constructs the payment options including the transaction amount, the item or service name, description, and pre-filled user contact information and email
  void makePayment() async {
    var options = {
      'key': "rzp_test_BxTVf62szh3KhA",
      'amount': 20000,
      'name': "User 1",
      'description': "Iphone 15",
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

// Initializes the Razorpay object and sets up the necessary event listeners for handling the payment responses.
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          makePayment();
        },
        child: Text("PayNow"),
      ),
    ));
  }
}
