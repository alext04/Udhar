import 'package:flutter/material.dart';

import 'admin_model.dart';

// page for each user when clicked on their widget in the view_users page
// shows profile , name and email
// sliders for rent and cards and when the bills to be paid are non zero , a button to make the payment for the user
class UserDetailPage extends StatelessWidget {
  final AppUser user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(186, 14, 14, 14), // Semi-transparent background
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
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
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 18, 5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                
              ),
              SizedBox(height: 10),
              Text(user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  )),
              Text(user.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  )),
              Text(user.phone,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  )),

              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ExpansionTile(
                      title: Text('Cards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Color.fromARGB(255, 0, 64, 14),
                      children: <Widget>[
                        // ListTile(
                        //   title: Text('Cards Added: ${user.cardsAdded}', style: TextStyle(color: Colors.white)),
                        //   subtitle: Text('Date Added: ${user.dateAdded}', style: TextStyle(color: Colors.grey)),
                        //   trailing: Text('\u{20B9}${user.cardAmount}', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        // ),
                        // ListTile(
                        //   title: Text('Due Date: ${user.cardDueDate}', style: TextStyle(color: Colors.white)),
                        // ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Rent', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Color.fromARGB(255, 0, 64, 14),
                      children: <Widget>[
                        // ListTile(
                        //   title: Text('Total Properties: ${user.amountOwed}', style: TextStyle(color: Colors.white)),
                        //   subtitle: Text('Due Date: ${user.rentDueDate}', style: TextStyle(color: Colors.grey)),
                        // ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Recent Payments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Color.fromARGB(255, 0, 64, 14),
                      children: <Widget>[
                        ListTile(
                          title: Text('Payment ID: 12', style: TextStyle(color: Colors.white)),
                          subtitle: Text('Date: 12/3', style: TextStyle(color: Colors.grey)),
                          trailing: Text('\u{20B9}123', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        ),
                        //   title: Text('Payment ID: ${Payment.paymentId}', style: TextStyle(color: Colors.white)),
                        //   subtitle: Text('Date: ${Payment.paymentDate}', style: TextStyle(color: Colors.grey)),
                        //   trailing: Text('\$${Payment.paymentAmount}', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        // ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}