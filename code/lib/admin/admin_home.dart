import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:udhar/widgets/home_page/balance_card.dart';


import 'admin_buttonrow.dart';
import 'admin_appbar.dart';
import 'admin_quickview.dart';
import 'admin_plots.dart';

// the homepage for the admin contains a summary of the app , a row of buttons providing access to other pages
// analytics for the page is also present at the present 
class AdminPage extends StatelessWidget {

  const AdminPage({Key? key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AdminAppBar(),
       body: SingleChildScrollView(  // Use SingleChildScrollView
        child: Column(
          children: <Widget>[
            // Uncomment and use as needed:
            // Text(user.email.toString()),
            // BalanceCard(user: user),
            SizedBox(height: 10),
            BoxWidget(),
            SizedBox(height: 20),
            ActionButtonRow(),
            SizedBox(height: 20),
            GraphsWidget(),
            SizedBox(height: 20),  // Added SizedBox for better spacing at the bottom
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}





