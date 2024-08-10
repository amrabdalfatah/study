// import 'package:cloud_firestore/cloud_firestore.dart';

// class FireStoreMember {
//   final CollectionReference _memberCollectionRef =
//       FirebaseFirestore.instance.collection('Members');

//   Future<void> addMemberToFirestore(MemberModel member) async {
//     return await _memberCollectionRef.doc(member.memberId).set(
//           member.toJson(),
//         );
//   }

//   checkMember(String uid) async {
//     var data = await _memberCollectionRef.doc(uid).get();
//     return data.exists;
//   }

//   Future<DocumentSnapshot> getCurrentMember(String mid) async {
//     return await _memberCollectionRef.doc(mid).get();
//   }

//   Future<void> updateMemberInfo({
//     required String key,
//     required dynamic value,
//     required String memberId,
//   }) async {
//     return await _memberCollectionRef.doc(memberId).update({
//       key: value,
//     });
//   }

//   Future<void> deleteMember(String mid) async {
//     return await _memberCollectionRef.doc(mid).delete();
//   }
// }