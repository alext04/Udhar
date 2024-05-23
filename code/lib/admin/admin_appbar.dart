// lib/utils/custom_app_bar.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/admin/admin_notifications.dart';

import 'dart:ui';
import 'admin_nav.dart';
import 'admin_home.dart';
import '../screens/notification_page.dart';


// class that is used as the appbar across the entire admin dashboard , it has quick links to home and alerts
// it navigates to the navbar when clicking the profile picture
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  AdminAppBar({Key? key}) : super(key: key);


  // const CustomAppBar({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    // return 
    // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
    //       final userData = snapshot.data!.data()!;
    //       final name = userData['name'] ?? 'Admin';

          return AppBar(
            backgroundColor: Color.fromARGB(255, 0, 32, 4),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AdminNavPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(-0.5,
                              0.0); // Start from the left, covering half of the screen
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return Stack(
                            children: [
                              // Background (Blurred)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pop(), // Tap to go back
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      color: Color.fromARGB(0, 255, 251, 251)
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              // Sliding Page
                              SlideTransition(
                                position: offsetAnimation,
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.75, // Cover half the screen
                                  child: child,
                                ),
                              ),
                            ],
                          );
                        },
                        transitionDuration: Duration(milliseconds: 300),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/default_profile.jpg.avif'),
                  ),
                ),
              ),
            ),
            title: Text(
              // user.displayName ?? "Name Null",
              // "Alex",
              "Admin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: false,
            actions: <Widget>[
              // Ic123456789
              IconButton(
                icon: Icon(Icons.home_filled, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminPage()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminNotifications()),
                  );
                },
              ),
            ],
          );
        // });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
