import 'package:cloud_firestore/cloud_firestore.dart';

import '../../authentication/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").where("id", isEqualTo: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnap = querySnapshot.docs[0];
      if (docSnap.data() != null) {
        userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
      }
    }
    return userModel;
  }
}
