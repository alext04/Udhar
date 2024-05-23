import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/admin/view_data.dart';

import 'admin_buttonrow.dart';
import 'admin_appbar.dart';
import 'user_detailed.dart';

import 'admin_model.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({Key? key}) : super(key: key);

  @override
  _ViewUserPageState createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  List<AppUser> users = [];

  List<AppUser> filteredUsers = [];
  String searchQuery = "";

  getUsers() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users.clear();
      for (final document in querySnapshot.docs) {
        users.add(AppUser(
            uid: document.id,
            name: document.data()['name'],
            email: document.data()['email'],
            phone: document.data()['phoneNumber'],
            image: document.data()['profilePictureUrl']));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    filteredUsers = users; // Initially filteredUsers is same as all users
  }

  void _filterUsers() {
    searchQuery = searchController.text;
    List<AppUser> tmpList = [];
    if (searchQuery.isNotEmpty) {
      tmpList.addAll(users.where(
        (user) => user.name.toLowerCase().contains(searchQuery.toLowerCase()),
      ));
    } else {
      tmpList = List<AppUser>.from(users);
    }
    setState(() {
      filteredUsers = tmpList;
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AdminAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                          color: Colors.white), // Set the text color to white
                      decoration: InputDecoration(
                        labelText: 'Search by name',
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 132, 132, 132)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _filterUsers,
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 19.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  AppUser currentUser = filteredUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(30.0), // Set the border radius
                      child: Card(
                        color: Color.fromARGB(255, 0, 27, 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              // Navigator.of(context).push(PageRouteBuilder(
                              //   opaque: false,
                              //   pageBuilder: (BuildContext context, _, __) {
                              //     return UserDetailPage(user: currentUser);
                              //   },
                              //   transitionsBuilder: (___,
                              //       Animation<double> animation,
                              //       ____,
                              //       Widget child) {
                              //     return FadeTransition(
                              //       opacity: animation,
                              //       child: child,
                              //     );
                              //   },
                              // ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewData(user: currentUser)));
                            },
                            title: Text(currentUser.name,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                              currentUser.email,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
