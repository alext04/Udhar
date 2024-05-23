import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/screens/add_card.dart';
import 'package:udhar/widgets/home_page/added_cards.dart';
import '../widgets/home_page/balance_card.dart';
import '../widgets/home_page/button_row.dart';
import '../widgets/home_page/recent_transactions.dart';
import '../widgets/home_page/bottom_nav.dart';
import '../utils/app_bar.dart';


// serves as the main dashboard for users once they are logged into the app. This screen is structured to provide an overview of a user's financial cards, balances, and recent transactions
class HomePage extends StatelessWidget {
  final User user;

  // content is scrollable when it exceeds the screen height
  const HomePage({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user:user),
      body: SingleChildScrollView(
        child: Column(
          
          children: <Widget>[
            // Text(user.email.toString())
            SizedBox(height: 10),
            BalanceCard(user: user),
            ActionButtonRow(user: user),
            SizedBox(height: 20),
            
            ModularHorizontalList(user: user),
            SizedBox(height: 20),
            CardsAdded(user : user),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
