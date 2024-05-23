import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/screens/add_rent.dart';
import 'package:udhar/screens/display_cards.dart';
import 'package:udhar/screens/login_screen.dart';
import 'package:udhar/screens/payments.dart';
import 'package:udhar/screens/transactions.dart';
import 'profile_page.dart';
import 'rent_page.dart';
import 'settings_page.dart';
import 'dart:ui';
import '../utils/app_bar.dart';
import 'add_card.dart';
import 'home_page.dart';
import 'make_payment.dart';
import 'notification_page.dart';
import 'display_cards.dart';
import '../admin/admin_home.dart';


//  serve as the main navigation drawer or dashboard from which a user can access different parts of the application.
class NavBarPage extends StatelessWidget {
  final User user;

  const NavBarPage({Key? key, required this.user});

  // listen to updates in real-time from Firestore concerning the logged-in user's data.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
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
          final name = userData['name'] ?? 'N/A';
        final imageURL = userData['profilePictureUrl']; 

          // A scrollable list that contains various ListTile widgets. Each tile is associated with an icon and a title representing different functionalities or sections of the app.
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 6, 4, 81),

            body: Column(
              children: <Widget>[
                // Top third with background image, profile picture, and name
                Expanded(
                  flex: 1,
                  child: Container(
                    // color: const Color.fromARGB(255, 103, 21, 21),
                    padding: EdgeInsets.only(top: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/nav_background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        imageURL!=null && imageURL !='' && imageURL!='null'? CircleAvatar(
                        backgroundImage: NetworkImage( imageURL
                            ),
                        radius :THelper.screenHeight()*0.07,
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/default_profile.jpg.avif'),
                        // radius: 50,
                        radius :THelper.screenHeight()*0.07,

                      ),
                        SizedBox(height: 8),
                        Text(
                          name ?? "Name Null",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Middle two-thirds with a list of pages
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.home, color: Colors.white),
                        title:
                            Text('Home', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Home

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.white),
                        title: Text('Credit Card',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Credit Card
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayCards(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.house, color: Colors.white),
                        title:
                            Text('Rent', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Rent
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewRent(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.payment, color: Colors.white),
                        title: Text('Payment',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Payment
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentForm(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.payment, color: Colors.white),
                        title: Text('History',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Payment
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionsPage(user: user)),
                          );
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.history, color: Colors.white),
                      //   title: Text('',
                      //       style: TextStyle(color: Colors.white)),
                      //   onTap: () {
                      //     // Navigate to Transaction History
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => AddCards(user:user)),
                      //       );
                      //   },
                      // ),
                      ListTile(
                        leading: Icon(Icons.add_card, color: Colors.white),
                        title: Text('Add Card',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Transaction History
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCards(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add_home, color: Colors.white),
                        title: Text('Add Property',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Transaction History
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRent(user: user)),
                          );
                        },
                      ),
                      Divider(color: Colors.white54),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text('Profile',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Profile
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(user: user)),
                          );
                        },
                      ), // A thin white divider
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.white),
                        title: Text('Settings',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Settings
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage(user: user)),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications, color: Colors.white),
                        title: Text('Notifications',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Notifications
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotificationPage(user: user)),
                          );
                        },
                      ),
                      
                      
                    ],
                  ),
                ),
                // Bottom section with a logout button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle logout
                        logout(context);
                      },
                      child: Text('Logout'.toUpperCase(),style: TextStyle(color: Color.fromARGB(229, 3, 68, 231),fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: CustomBottomNavigationBar(),
          );
        });
  }
}
// Asynchronously signs out the user from Firebase Authentication.
void logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Navigate to login screen after logout
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(title: 'LOGIN'),
    ),
  );
}
