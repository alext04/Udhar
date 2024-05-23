import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/admin/admin_model.dart';


import 'admin_appbar.dart';


// page to allow a future implement of a page for admin to view transacation that are urgent
// required only when app grows to a larger scale when individual user payment acceptance becomes tedious
class PaymentsPage extends StatefulWidget {

  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _ViewUpcomingPaymentsPageState createState() => _ViewUpcomingPaymentsPageState();
}


class _ViewUpcomingPaymentsPageState extends State<PaymentsPage> {
  
  List<Payment> payments = [
    Payment(
      id: '1',
      payeeName: 'John Doe',
      dueDate: DateTime(2024, 5, 22),
      amount: 150.00,
    ),
    Payment(
      id: '2',
      payeeName: 'Jane Smith',
      dueDate: DateTime(2023, 3, 22),
      amount: 200.00,
    ),
     Payment(
      id: '3',
      payeeName: 'Jane Doe',
      dueDate: DateTime(2023, 2, 22),
      amount: 20000.00,
    ),
     Payment(
      id: '4',
      payeeName: 'John Smith',
      dueDate: DateTime(2024, 5, 22),
      amount: 80000.00,
    ),
    // Add more payments as needed
  ];

  List<Payment> filteredPayments = [];
  String searchQuery = "";
  RangeValues amountRange = RangeValues(0,100000); // Assuming an initial range

  @override
  void initState() {
    super.initState();
    payments.sort((b, a) => a.dueDate.compareTo(b.dueDate));
    filteredPayments = payments; // Initially filteredPayments is same as all payments
    _filterPayments(); // Apply filters on init
  }

  void _filterPayments() {
    List<Payment> tmpList = [];
    if (searchQuery.isNotEmpty) {
      tmpList.addAll(payments.where(
        (payment) => payment.payeeName.toLowerCase().contains(searchQuery.toLowerCase()),
      ));
    } else {
      tmpList = List<Payment>.from(payments);
    }
    tmpList = tmpList.where((payment) =>
        payment.amount >= amountRange.start && payment.amount <= amountRange.end).toList();
    setState(() {
      filteredPayments = tmpList;
    });
  }
  
void reset() {
    if (payments.isNotEmpty) {
        setState(() {
            // Reset the search query if there's any
            searchQuery = "";
            // Resetting filteredPayments to show all payments
            filteredPayments = List<Payment>.from(payments); 
            // Set amountRange to a fixed wide range to include all possible amounts
            amountRange = RangeValues(0, 100000);
            _filterPayments(); // Reapply filters after resetting the range
        });
    }
}


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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Search by name',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 132, 132, 132)),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          _filterPayments();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _filterPayments,
                  ),
                  IconButton(
                      icon: Icon(Icons.refresh_outlined, color: Colors.white),
                      onPressed: reset, // Reset to initial range
                      tooltip: 'Reset Filter',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: RangeSlider(
                      values: amountRange,
                      min: 0,
                      max: 100000,
                      divisions: 100,
                      labels: RangeLabels(
                        '\$${amountRange.start.toStringAsFixed(0)}',
                        '\$${amountRange.end.toStringAsFixed(0)}'
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          amountRange = values;
                        });
                      },
                    ),
                  ),
                  
                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.green),
                    onPressed: _filterPayments,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredPayments.length,
                itemBuilder: (BuildContext context, int index) {
                  Payment currentPayment = filteredPayments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Card(
                        color: Color.fromARGB(255, 0, 27, 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {}, // Tap action can be defined here
                            title: Text(currentPayment.payeeName, style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                              'Due Before: ${currentPayment.dueDate.toString().substring(0, 10)}\nAmount: \u{20B9}${currentPayment.amount}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                // Implement payment approval functionality
                              },
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

