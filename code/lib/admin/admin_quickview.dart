import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// widget called on the home screen to display a summary of earning and users of the app
// very modular and the structure can be changed easily 
// currently with prefilled users due to no user data
class BoxWidget extends StatelessWidget {

  const BoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3, // Changed from 2 to 3 for more items per row if required
        crossAxisSpacing: 20,
        mainAxisSpacing: 25, 
        shrinkWrap: true,
        children: <Widget>[
          _buildCard('\u{20B9}8976.55', 'Due Today'),
          _buildCard('1230.00', 'Payments Today'),
          _buildCard('15', 'Active Users'),
          _buildCard('120', 'Last Month Total'),
          _buildCard('\u{20B9}120', 'Total Debt'),
          _buildCard('120', 'New Users'),
        ],
      ),
    );
  }

  Widget _buildCard(String number, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 230, 142), // Lighter green
            Color.fromARGB(255, 0, 22, 7), // Darker green
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15, // Reduced font size for numbers
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10, // Reduced font size for captions
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
