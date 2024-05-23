import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/app_bar.dart';
import 'add_rent.dart';

// lass serves as a data model for rent information, encapsulating the title, balance, and dueDate of a rental entry used to structure the data fetched from Firestore.
class RentModel {
  final String title;
  final String balance;
  final String dueDate;

  const RentModel({
    required this.title,
    required this.balance,
    required this.dueDate,
  });
}

// acts as a container for displaying rental information.  initializes the UI with a custom AppBar and a body that includes the RentScreen, tailored for viewing rent details.
class ViewRent extends StatelessWidget {
  final User user;

  ViewRent({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user: user),
      body: RentScreen(user: user),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

// allows for dynamic interaction, primarily the display of rent details stored in Firestore.
class RentScreen extends StatefulWidget {
  final User user;

  RentScreen({Key? key, required this.user});
  @override
  _RentScreenState createState() => _RentScreenState(user: user);
}

// Manages the list of rent entries (_rentInfoList) fetched from Firestore.
class _RentScreenState extends State<RentScreen> {
  final User user;

  // Handles page controls with a PageController to navigate between different rent entries using a swiping interface.

  _RentScreenState({Key? key, required this.user});
  List<RentModel> _rentInfoList = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _numPages = 2;

  @override
  void initState() {
    super.initState();
    _fetchRentInfo();
  }

  // to load rental data from Firestore and populates the UI.
  Future<void> _fetchRentInfo() async {
    final rentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Rents');
    final querySnapshot = await rentRef.get();
    _rentInfoList.clear();
    for (var doc in querySnapshot.docs) {
      final rentInfo = doc.data();
      final curr = RentModel(
        title: rentInfo['title'] ?? 'N/A',
        balance: rentInfo['balance'] ?? 'N/A',
        dueDate: rentInfo['dueDate'] ?? 'N/A',
      );
      _rentInfoList.add(curr);
    }
    _numPages = _rentInfoList.toList().length;
    setState(() {});
  }

  Widget _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color.fromARGB(255, 139, 0, 167) : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  // UI interface for the user to interact with
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _rentInfoList
                  .map((rentInfo) => RentInfoCard(
                        title: rentInfo.title,
                        amount: rentInfo.balance,
                        dueDate: rentInfo.dueDate,
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: _buildPageIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRent(user: user)),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.purple,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return PaymentCard(
                  title: 'Payment Title $index',
                  subtitle: 'Payment Subtitle',
                  amount: index % 2 == 0
                      ? '- \$${(index + 1) * 25}.00'
                      : '+ \$${(index + 1) * 75}.00',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// display individual rental information: rental title, amount, and due date in a visually appealing card format.
class RentInfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final String dueDate;

  const RentInfoCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.dueDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 217, 0, 255),
              Color.fromARGB(255, 36, 2, 162)
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(height: 8),
              Text(
                '\$$amount',
                style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Due $dueDate',
                style: TextStyle(
                    fontSize: 18, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// displays the past payments made for rent
class PaymentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const PaymentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
              Text(subtitle, style: TextStyle(color: Colors.white54)),
            ],
          ),
          Text(amount,
              style: TextStyle(
                  color: Color.fromARGB(255, 249, 229, 254), fontSize: 18)),
        ],
      ),
    );
  }
}

//



