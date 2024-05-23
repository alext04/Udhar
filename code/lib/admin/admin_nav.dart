import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/admin/admin_home.dart';
import 'package:udhar/admin/admin_notifications.dart';
import 'package:udhar/admin/admin_payment.dart';
import 'package:udhar/admin/view_data.dart';
import 'package:udhar/admin/view_users.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/screens/add_rent.dart';
import 'package:udhar/screens/home_page.dart';
import 'package:udhar/screens/login_screen.dart';

import 'dart:ui';

// the side nav bar for the admin dashboard , providing links to all the pages in the dashboard
class AdminNavPage extends StatelessWidget {

  const AdminNavPage({Key? key});
  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    //     stream: FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(user.uid)
    //         .snapshots(),
    //     // .collection('Cards')
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator(); // Show loading indicator
    //       }
    //       if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}'); // Show error message
    //       }
    //       if (!snapshot.hasData) {
    //         return Text('No cards available'); // Show no cards message
    //       }
          // final userData = snapshot.data!.data()!;
          // final name = userData['name'] ?? 'N/A';
          // final imageURL = userData['profilePictureUrl'];

          return Scaffold(
            backgroundColor: Color.fromARGB(255, 0, 52, 24),

            body: Column(
              children: <Widget>[
                // Top third with background image, profile picture, and name
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     // color: const Color.fromARGB(255, 103, 21, 21),
                //     padding: EdgeInsets.only(top: 35.0),
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage("assets/images/nav_background.jpg"),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         imageURL != null && imageURL != '' && imageURL != 'null'
                //             ? CircleAvatar(
                //                 backgroundImage: NetworkImage(imageURL),
                //                 radius: THelper.screenHeight() * 0.07,
                //               )
                //             : CircleAvatar(
                //                 backgroundImage: AssetImage(
                //                     'assets/images/default_profile.jpg.avif'),
                //                 // radius: 50,
                //                 radius: THelper.screenHeight() * 0.07,
                //               ),
                //         SizedBox(height: 8),
                //         Text(
                //           name ?? "Name Null",
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                                builder: (context) => AdminPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.white),
                        title: Text('View Users',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Credit Card
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewUserPage()),
                          );
                        },
                      ),
                      
                      ListTile(
                        leading: Icon(Icons.house, color: Colors.white),
                        title: Text('Urgent Transaction',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Rent
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentsPage()),
                          );
                        },
                      ),

                      Divider(color: Colors.white54), // A thin white divider
                      // ListTile(
                      //   leading: Icon(Icons.settings, color: Colors.white),
                      //   title: Text('Settings',
                      //       style: TextStyle(color: Colors.white)),
                      //   onTap: () {
                      //     // Navigate to Settings
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => SettingsPage(user: user)),
                      //     );
                      //   },
                      // ),
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
                                    AdminNotifications()),
                          );
                        },
                      ),
                      
                      // ListTile(
                      //   leading: Icon(Icons.person, color: Colors.white),
                      //   title: Text('Profile',
                      //       style: TextStyle(color: Colors.white)),
                      //   onTap: () {
                      //     // Navigate to Profile
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ProfilePage(user: user)),
                      //     );
                      //   },
                      // ),
                      // ListTile(
                      //   leading: Icon(Icons.person, color: Colors.white),
                      //   title: Text('back to main app (temp)',
                      //       style: TextStyle(color: Colors.white)),
                      //   onTap: () {
                      //     // Navigate to Profile
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => HomePage(user: user)),
                      //     );
                      //   },
                      // ),
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
                      child: Text('Logout'),
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: CustomBottomNavigationBar(),
          );
        // });
  }
}

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
