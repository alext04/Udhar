import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udhar/screens/rent_page.dart';
import '../utils/app_bar.dart';


// uses the AddRentScreen widget to allow users to input new rent data.
class AddRent extends StatelessWidget {
  final User user;

  AddRent({Key? key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      appBar: CustomAppBar(user: user),
      body: AddRentScreen(user: user),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

// creates a dynamic interface allowing users to enter details about a rental agreement such as the title, amount, and due date.
class AddRentScreen extends StatefulWidget {
  const AddRentScreen({super.key, required this.user});
  final User user;
  @override
  _AddRentScreenState createState() => _AddRentScreenState();
}

// handling interactive and stateful aspects like form submissions and date selection.
class _AddRentScreenState extends State<AddRentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? rentAmount;
  String? dueDate;
  DateTime? selectedDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

  final Map<String, dynamic> rentData = {
    'title': '',
    'balance': '',
    'dueDate': '',
  };

  // date picker 
  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('dd/MM/yy').format(picked);
      setState(() {
        selectedDate = picked;
        dueDate = DateFormat('dd MMM').format(picked);
      });
      return formattedDate;
    } else {
      return "";
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white), // Make the label text white
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _gradientBackground({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.6),
            const Color.fromARGB(255, 74, 30, 233).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }

  // method validates the form and, upon success, adds the rent data to Firestore and navigates to the ViewRent screen 
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      rentData['balance'] = balanceController.text;
      rentData['title'] = titleController.text;
      setState(() {});
      var val = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('Rents');

      await val.add(rentData);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewRent(user: widget.user)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitting form')),
      );
    }
  }

  // creates the UI for the user to enter information
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 17, 22),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'ADD PROPERTY',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _gradientBackground(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Rent title
                        TextFormField(
                          controller: titleController,
                          decoration: _inputDecoration('Title'),
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              title = titleController.text;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        // rent amount
                        TextFormField(
                          controller: balanceController,
                          decoration: _inputDecoration('Rent Amount'),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the rent amount';
                            }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              title = balanceController.text;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        // Due Date
                        TextFormField(
                          decoration: _inputDecoration('Due Date'),
                          style: TextStyle(color: Colors.white),
                          controller: TextEditingController(text: dueDate),
                          readOnly: true,
                          onTap: () async {
                            rentData['dueDate'] = await _selectDate(context);
                          },
                        ),
                        SizedBox(height: 16),
                        // submit button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),

                            ),
                            child: Text('SUBMIT'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
