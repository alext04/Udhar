import 'package:flutter/material.dart';


// Not being used for now
class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFF120142), // Adjust to match your primary dark color
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.account_balance, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add_card_outlined, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.home_work, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person_3, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
