// import 'package:cloud_firestore/cloud_firestore.dart';

// class FireStoreUser {
//   final CollectionReference _userCollectionRef =
//       FirebaseFirestore.instance.collection('Users');

//   Future<QuerySnapshot> getUsers() async {
//     return await _userCollectionRef.get();
//   }

//   Future<void> addUserToFirestore(UserModel userModel) async {
//     return await _userCollectionRef.doc(userModel.userId).set(
//           userModel.toJson(),
//         );
//   }

//   checkUser(String uid) async {
//     var data = await _userCollectionRef.doc(uid).get();
//     return data.exists;
//   }

//   Future<DocumentSnapshot> getCurrentUser(String uid) async {
//     return await _userCollectionRef.doc(uid).get();
//   }

//   Future<void> updateUserInfo({
//     required String key,
//     required dynamic value,
//     required UserModel userModel,
//   }) async {
//     return await _userCollectionRef.doc(userModel.userId).update({
//       key: value,
//     });
//   }
// }