import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/screens/profile_page.dart';
import 'package:udhar/utils/app_bar.dart';

// that provides a form for users to update their profile data. Initializes with a user object, indicating the current authenticated user.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final User user;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

// Manages the state of EditProfilePage, including form controllers and the initial fetching of user data.
class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _dobController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();

  // Retrieves initial user data from Firestore
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String? imageURL;
  String? imageURL2;

  Future<void> _fetchUserData() async {
    final uid = widget.user.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      _nameController.text = userData!['name'] ?? '';
      _dobController.text = userData['dob'] ?? ''; // Set default value if not found
       // Set default value if not found
      _addressController.text = userData['Address'] ?? '';

      setState(() {
        imageURL2 = userData['profilePictureUrl'] ?? '';
        
      });
      print(imageURL2);
      // Set default value if not found
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // called to save the updated data to Firestore. If a new image is selected, it's uploaded first, and its URL is saved along with other user data.
  Future<void> updateUserInformation() async {
    final uid = widget.user.uid;
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();
    final address = _addressController.text.trim();

    if (_image != null && im != null) {
      imageURL = await uploadImage(im!); // Wait for upload to complete
    } else {
      imageURL = imageURL2;
    }
    // Update user data in Firebase Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await userRef.update({
      'name': name,
      'dob': dob, // Add phone and address fields if needed in your schema
      'Address': address,
      'profilePictureUrl':
          imageURL // Add phone and address fields if needed in your schema
    });
  }

  Uint8List? _image;
  XFile? im;
  // Opens the image picker for the user to select a new profile picture.
  changeProfilePhoto() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List? img = await file.readAsBytes();
      setState(() {
        _image = img;
        im = file;
      });
    }
  }
  //  Uploads the selected image to Firebase Storage and retrieves the URL to be stored in Firestore
  Future<String> uploadImage(XFile im) async {
    final storage = FirebaseStorage.instance;
    final uid = widget.user.uid;
    final reference = storage.ref().child('profile_pics/${uid}.jpg');
    final uploadTask = reference.putFile(File(im.path));

    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    setState(() {
      imageURL = url;
    });
    // imageURL = url;
    return url;
  }

  // Provides a UI with a gradient background and styled form fields, along with a button to submit changes. The profile picture can be tapped to change it.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user: widget.user),
      body: Container(
        height: THelper.screenHeight(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo, Colors.purple, Colors.blue],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:25 , horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 17, 22).withOpacity(0.75),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                changeProfilePhoto();
                              },
                              child: CircleAvatar(
                                radius: THelper.screenWidth()/4,
                                backgroundImage: MemoryImage(_image!),
                              ),
                            ),
                            // child: Image(image: MemoryImage(_image!)),
                          )
                        : imageURL2 != null && imageURL2 != ''
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    changeProfilePhoto();
                                  },
                                  child: CircleAvatar(
                                radius: THelper.screenWidth()/4,
                                    backgroundImage: NetworkImage(imageURL2!),
                                  ),
                                ),
                                // child: Image(image: MemoryImage(_image!)),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    changeProfilePhoto();
                                  },
                                  child: CircleAvatar(
                                radius: THelper.screenWidth()/4,
                                    backgroundImage: AssetImage(
                                        'assets/images/default_profile.jpg.avif'),
                                  ),
                                ),
                              ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),

                    TextFormField(
                      controller: _dobController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'DOB',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                   
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // if (_image != null && im != null) {
                            //   uploadImage(im!);
                            //   print(imageURL);
                            // }

                            updateUserInformation();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(user: widget.user)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(150, 45, 60, 32),
                          foregroundColor: Colors.lightBlue,
                        ),
                        child: Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}