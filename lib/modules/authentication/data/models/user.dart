import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String email;
  final String userName;
  final String phoneNumber;

  Users({
    required this.id,
    required this.email,
    required this.userName,
    required this.phoneNumber,
  });

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Users(
      id: doc.id,
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
    };
  }
}
