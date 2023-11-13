import 'package:cloud_firestore/cloud_firestore.dart';

class BankModel {
  String? id;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? accountHolderName;
  String? userId;

  BankModel({this.id, this.accountNumber, this.ifscCode, this.bankName, this.accountHolderName, this.userId});

  toJson() {
    return {
      "AccountNumber": accountNumber,
      "IfscCode": ifscCode,
      "BankName": bankName,
      "AccountHolderName": accountHolderName,
    };
  }

  factory BankModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BankModel(
      id: document.id,
      accountNumber: data["AccountNumber"],
      ifscCode: data["IfscCode"],
      bankName: data["BankName"],
      accountHolderName: data["AccountHolderName"],
      userId: data["Email"],
    );
  }
}
