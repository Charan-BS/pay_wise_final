import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? fullName;
  String? email;
  String? deviceToken = "notFetched";

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.deviceToken,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "id": id,
      "deviceToken": deviceToken,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    fullName = map["FullName"];
    email = map["Email"];
    deviceToken = map["deviceToken"];
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      fullName: data["FullName"],
      email: data["Email"],
      deviceToken: data["deviceToken"],
    );
  }
}
