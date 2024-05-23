import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/screens/edit_profile_page.dart';

import '../utils/app_bar.dart';

// provide a detailed view of the user's profile, including personal details like name, email, phone number, and address, as well as payment-related information such as card details and due balances.
class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Displays the user's profile picture, name, email, and other personal details dynamically fetched from Firestore.
class _ProfilePageState extends State<ProfilePage> {
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

//Calculates total balances from multiple sources (Cards and Rents collections) to provide a comprehensive view of the user's financial status.
  Future<void> _fetchBalance() async {
    final uid = widget.user.uid;
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
    });
  }

  // Builds the UI based on the data fetched from Firestore, dynamically adjusting content like images and text fields based on the available user data
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .snapshots(),
        // .collection('Cards')
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
          final userData = snapshot.data!.data()!;
          final imageURL = userData['profilePictureUrl'];
          final email = userData['email'];
          final name = userData['name'];
          final phone = userData['phoneNumber'];
          final address = userData['Address'];
          final dob = userData['dob'];

          return Scaffold(
            backgroundColor: Color.fromARGB(255, 15, 17, 22),
            appBar: CustomAppBar(user: widget.user),
            body: Stack(children: [
              SingleChildScrollView(
                // decoration: BoxDecoration(
                //     // gradient: LinearGradient(
                //     //   begin: Alignment.topLeft,
                //     //   end: Alignment.bottomRight,
                //     //   colors: [Colors.indigo, Colors.purple, Colors.blue],
                //     // ),
                //     ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 15, 17, 22)
                            .withOpacity(0.75), // Very Dark Violet
                        borderRadius: BorderRadius.circular(0.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imageURL != null
                                ? Container(
                                    width: THelper.screenWidth(),
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(imageURL!),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/default_profile.jpg.avif'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0), // Space between the photo and the name
                              Text(
                                name.toString().toUpperCase()!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.0), // Space between the name and the email
                              Text(
                                email ?? "email not verified",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                            ],
                          ),

                          SizedBox(height: 20.0),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 56, 1, 114),
                                  Color.fromARGB(255, 97, 0, 202),
                                  Color.fromARGB(255, 106, 0, 194),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account Information',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                ListTile(
                                  leading:
                                      Icon(Icons.phone, color: Colors.white),
                                  title: Text(
                                    phone ?? 'NA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: Colors.white),
                                  title: Text(
                                    address ?? 'NA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.date_range,
                                      color: Colors.white),
                                  title: Text(
                                    dob ?? 'NA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Divider(color: Colors.white),
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 56, 1, 114),
                                  Color.fromARGB(255, 97, 0, 202),
                                  Color.fromARGB(255, 106, 0, 194),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Information',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                ListTile(
                                  leading: Icon(Icons.credit_card,
                                      color: Colors.white),
                                  title: Text(
                                    'Card ending **** 1234',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.monetization_on,
                                      color: Colors.white),
                                  title: Text(
                                    'Due: ${totalBalance.toString()}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: (kBottomNavigationBarHeight * 0.3),
                left: THelper.screenWidth() / 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(user: widget.user)),
                    );
                    // _fetchData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 56, 1, 114),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Text('Edit Profile'),
                ),
              ),
            ]),
            // bottomNavigationBar: CustomBottomNavigationBar(),
          );
        });
  }
}