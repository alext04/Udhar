// defines the models used across the admin page

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? image;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });
}

class Payment {
  String id;
  String payeeName;
  DateTime dueDate;
  double amount;

  Payment(
      {required this.id,
      required this.payeeName,
      required this.dueDate,
      required this.amount});
}

class Cards {
  String? balance;
  String? cardHolderName;
  String? cardNumber;
  String? cvvCode;
  String? dueDate;
  String? expiryDate;


  Cards(
      {required this.balance,
      required this.cardHolderName,
      required this.dueDate,
      required this.cvvCode ,
      required this.expiryDate ,
      required this.cardNumber ,

      });
}

class Rent {
  String? balance;
  String? dueDate;
  String? title;


  Rent(
      {required this.balance,
      required this.title,
      required this.dueDate,

      });
}
