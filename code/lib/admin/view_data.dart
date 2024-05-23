import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:udhar/admin/admin_appbar.dart';
import 'package:udhar/admin/admin_model.dart';
import 'package:udhar/constants/colors.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/widgets/home_page/recent_transactions.dart';

class Transaction {
  String id;
  String date;
  String amount;

  Transaction({required this.id, required this.date, required this.amount});
}

// dynamic page to display the cards rent and transaction of a user
class ViewData extends StatefulWidget {
  const ViewData({super.key, required this.user});
  final AppUser user;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  int page = 1;
  List<Cards> cardList = [];
  List<Rent> rentList = [];
  List<Transaction> transactionList = [];

  getData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('Cards')
        .get();

    final querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('Rents')
        .get();

    final querySnapshot3 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('Transactions')
        .get();

    setState(() {
      for (final doc in querySnapshot.docs) {
        cardList.add(Cards(
            balance: doc.data()["balance"],
            cardHolderName: doc.data()["cardHolderName"],
            cardNumber: doc.data()["cardNumber"],
            cvvCode: doc.data()["cvvCode"],
            dueDate: doc.data()["dueDate"],
            expiryDate: doc.data()["expiryDate"]));
      }
      for (final doc in querySnapshot2.docs) {
        rentList.add(Rent(
            balance: doc.data()["balance"],
            dueDate: doc.data()["dueDate"],
            title: doc.data()["title"]));
      }

      for (final doc in querySnapshot3.docs) {
        transactionList.add(Transaction(
            id: doc.data()["paymentID"],
            date: doc.data()["dateTime"],
            amount: doc.data()["amount"]));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData(); // Initially filteredUsers is same as all users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24),
        ),
        backgroundColor: Color.fromARGB(255, 0, 32, 4),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(), // Go back on tap
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            widget.user.image == null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.user.image!),
                  ),
            SizedBox(height: 10),
            Text(widget.user.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text(widget.user.email,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(widget.user.phone,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        page = 1;
                      });
                    },
                    child: SizedBox(
                        width: THelper.screenWidth() / 3.5,
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: page == 1 ?  Color.fromARGB(255, 39, 176, 62) : Color.fromARGB(255, 0, 1, 0),
                          ),
                          child: Text(
                            "Cards",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: page == 1 ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
                            ),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        page = 2;
                      });
                    },
                    child: SizedBox(
                        width: THelper.screenWidth() / 3.5,
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: page == 2 ? Color.fromARGB(255, 39, 176, 62) : Color.fromARGB(255, 0, 1, 0),
                          ),
                          child: Text(
                            "Rent",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: page == 2 ? TColors.primary : Colors.white,
                            ),
                          ),
                        ))),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        page = 3;
                      });
                    },
                    child: SizedBox(
                        width: THelper.screenWidth() / 3.5,
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: page == 3 ? Color.fromARGB(255, 39, 176, 62) : Color.fromARGB(255, 0, 1, 0),
                          ),
                          child: Text(
                            "Transactions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: page == 3 ? TColors.primary : Colors.white,
                            ),
                          ),
                        ))),
              ],
            ),
            page == 1
                ? Column(
                    children: cardList
                        .map((card) => Tile2(
                              company: card.cardNumber.toString(),
                              date: card.dueDate.toString(),
                              amount: card.balance.toString(),
                            ))
                        .toList(),
                  )
                : page == 2
                    ? Column(
                        children: rentList
                            .map((card) => Tile2(
                                  company: card.title.toString(),
                                  date: card.dueDate.toString(),
                                  amount: card.balance.toString(),
                                ))
                            .toList(),
                      )
                    : Column(
                        children: transactionList
                            .map((card) => TransactionTile(
                                  company: card.id.toString(),
                                  date: card.date.toString(),
                                  amount: card.amount.toString(),
                                ))
                            .toList(),
                      ),
          ],
        ),
      ),
    );
  }
}

class Tile2 extends StatefulWidget {
  const Tile2(
      {super.key,
      required this.company,
      required this.date,
      required this.amount});
  final company, date;
  final String amount;

  @override
  State<Tile2> createState() => _Tile2State();
}

class _Tile2State extends State<Tile2> {
  Razorpay? _razorpay;

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
  void makePayment(String amount) async {
    var options = {
      'key': "rzp_test_BxTVf62szh3KhA",
      'amount': double.parse(amount) * 100,
      'name': "",
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          widget.company,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Amount: ${widget.amount} \nDate: ${widget.date} ",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: double.parse(widget.amount) != 0
            ? ElevatedButton(
                onPressed: () {
                  makePayment(widget.amount);
                },
                child: Text("PayNow"),
              )
            : SizedBox(height: 0, width: 0),
      ),
    );
  }
}
