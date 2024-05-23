import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart'; // Import your login screen file


// provide a main dashboard view in a Flutter application for authenticated users.
class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  // ncludes a navigation bar with a logout button and displays user details and their associated credit card information from a Firebase Firestore collection. 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'HOME',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontWeight: FontWeight.bold, // Set text to bold
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(0, 162, 197, 0.7),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome ${user.email}',
              style: const TextStyle(fontSize: 20),
            ),
            UserDetails(user: user),
          ],
        ),
      ),
    );
  }
  // The logout method uses FirebaseAuth to sign out the user and then navigates back to the 
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
}

// class UserDetails extends StatelessWidget {
//   final User user;

//   const UserDetails({Key? key, required this.user}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future:
//           FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Show loading indicator while fetching data
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}'); // Show error message if any
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return Text('No data available'); // Show message if no data found
//         }

//         // Extract user details from snapshot
//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final name = data['name'] ?? 'N/A';
//         final email = data['email'] ?? 'N/A';
//         final phoneNumber = data['phoneNumber'] ?? 'N/A';

//         return Column(
//           children: [
//             Text('Name: $name'),
//             Text('Email: $email'),
//             Text('Phone Number: $phoneNumber'),
//             // Add more fields as needed
//           ],
//         );
//       },
//     );
//   }
// }

// fetches provides visual feedback to users that data is being loaded, which is crucial for maintaining a responsive feel.
class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({Key? key, required this.user}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Cards')
          .snapshots(),
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

        final cards = snapshot.data!.docs;
        final List<String> cardNumbers = [];
        for (var card in cards) {
          final cardData = card.data() as Map<String, dynamic>;
          final cardNumber = cardData['card_no'] ?? 'N/A';
          cardNumbers.add(cardNumber);
        }

        return Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(); // No need for additional indicator here
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error message
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No data available'); // Show message if no data found
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final name = data['name'] ?? 'N/A';
                final email = data['email'] ?? 'N/A';
                final phoneNumber = data['phoneNumber'] ?? 'N/A';

                return Column(
                  children: [
                    Text('Name: $name'),
                    Text('Email: $email'),
                    Text('Phone Number: $phoneNumber'),
                  ],
                );
              },
            ),
            const SizedBox(height: 10), // Add spacing
            Text('Cards:'),
            Column(
              children: cardNumbers.map((cardNumber) => Text(cardNumber.toString())).toList(),
            ),
          ],
        );
      },
    );
  }
}
