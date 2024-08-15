// import 'dart:async';

// import 'package:alyamama_app/core/services/firestore_camera.dart';
// import 'package:alyamama_app/core/services/firestore_caseAlert.dart';
// import 'package:alyamama_app/core/services/firestore_member.dart';
// import 'package:alyamama_app/core/services/firestore_user.dart';
// import 'package:alyamama_app/core/utils/constants.dart';
// import 'package:alyamama_app/core/utils/dimensions.dart';
// import 'package:alyamama_app/features/home/views/add_member_with_face.dart';
// import 'package:alyamama_app/features/home/views/edit_member_with_face.dart';
// import 'package:alyamama_app/features/home/views/home_view.dart';
// import 'package:alyamama_app/model/camera_model.dart';
// import 'package:alyamama_app/model/case_alert_model.dart';
// import 'package:alyamama_app/model/member_model.dart';
// import 'package:alyamama_app/model/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';

// class HomeViewModel extends GetxController {
//   UserModel? userData;
//   MemberModel? memberData;
//   Stream<QuerySnapshot>? cameraSettings;
//   CameraModel cameraModel = CameraModel();
//   // List<CameraFace> cameraFaces = [];
//   ValueNotifier<bool> dataLoaded = ValueNotifier(false);
//   bool isOwner = AppConstants.typePerson == TypePerson.owner;
//   bool isMember = AppConstants.typePerson == TypePerson.member;

//   @override
//   void onInit() {
//     super.onInit();
//     if (isOwner) {
//       getUser();
//     } else if (isMember) {
//       getMember();
//     } else {
//       getDataForSecurityCompany();
//     }
//   }

//   Future<void> getUser() async {
//     await FireStoreUser().getCurrentUser(AppConstants.userId!).then((value) {
//       userData = UserModel.fromJson(value.data() as Map<dynamic, dynamic>?);
//     }).whenComplete(
//       () {
//         // getCameraData();
//         userData!.membersId!.forEach((String element) {
//           getMembers(element);
//         });
//       },
//     );
//     dataLoaded.value = true;
//     update();
//   }

//   void getMember() async {
//     await FireStoreMember()
//         .getCurrentMember(AppConstants.loginId!)
//         .then((value) {
//       memberData = MemberModel.fromJson(value.data() as Map<dynamic, dynamic>?);
//     });

//     dataLoaded.value = true;
//     update();
//   }

//   // List of cameras
//   List cameras = [];
//   List users = [];
//   void getDataForSecurityCompany() async {
//     await FireStoreCamera().getCameras().then((value) {
//       cameras = value.docs.map((e) {
//         return e.data();
//       }).toList();
//     }).whenComplete(() async {
//       await FireStoreUser().getUsers().then((value) {
//         users = value.docs.map((e) {
//           return e.data();
//         }).toList();
//       });
//       dataLoaded.value = true;
//       update();
//     });
//   }

//   // void getCameraData() async {
//   //   await FireStoreCamera()
//   //       .getCurrentCamera(userData!.cameraId!)
//   //       .then((value) async {
//   //     print('//////// Camera //////');
//   //     print(value.data());
//   //     await FireStoreCamera().getFacesCamera(userData!.cameraId!).then((camFa) {
//   //       print(camFa.docs.map((e) => print(e.data())));
//   //     });
//   //   });
//   // }

//   Future<void> signOut() async {
//     FirebaseAuth.instance.signOut();
//   }

//   // DashBoard View
//   var daily = false.obs;
//   var weekly = false.obs;
//   var monthly = false.obs;

//   getReportData(int report) {
//     switch (report) {
//       case 1:
//         daily.value = true;
//         weekly.value = false;
//         monthly.value = false;
//         break;
//       case 3:
//         daily.value = false;
//         weekly.value = true;
//         monthly.value = false;
//         break;
//       case 10:
//         daily.value = false;
//         weekly.value = false;
//         monthly.value = true;
//     }
//   }

//   void changeToDaily() async {
//     daily.value = true;
//     weekly.value = false;
//     monthly.value = false;
//     await FireStoreUser()
//         .updateUserInfo(
//       key: 'report',
//       value: 1,
//       userModel: userData!,
//     )
//         .then((value) async {
//       await getUser();
//     });
//   }

//   void changeToWeekly() async {
//     daily.value = false;
//     weekly.value = true;
//     monthly.value = false;
//     await FireStoreUser()
//         .updateUserInfo(
//       key: 'report',
//       value: 3,
//       userModel: userData!,
//     )
//         .then((value) async {
//       await getUser();
//     });
//   }

//   void changeToMonthly() async {
//     daily.value = false;
//     weekly.value = false;
//     monthly.value = true;
//     await FireStoreUser()
//         .updateUserInfo(
//       key: 'report',
//       value: 10,
//       userModel: userData!,
//     )
//         .then((value) async {
//       await getUser();
//     });
//   }

//   Color changeColor(String? lastSeen) {
//     print("Last Seen $lastSeen");
//     var actTime = DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.now());
//     // String actminutes = actTime[14] + actTime[15];
//     print("Act Time $actTime");
//     int lastMinutes = int.parse(lastSeen![14] + lastSeen[15]);
//     int lastHours = int.parse(lastSeen[11] + lastSeen[12]);
//     int actMinutes = int.parse(actTime[14] + actTime[15]);
//     int actHour = int.parse(actTime[11] + actTime[12]);

//     var minutesReported = userData!.report;

//     if (lastMinutes + minutesReported! < actMinutes && lastHours <= actHour) {
//       return Colors.red;
//     } else {
//       return Colors.green;
//     }
//   }

//   // Add Members Screen
//   PageController pageController = PageController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String email = '', password = '', firstName = '', lastName = '';
//   String memberId = '';
//   var shownPassword = true.obs;

//   void changeShownPassword() {
//     shownPassword.value = !shownPassword.value;
//   }

// // Timer
//   Timer? timer;
//   var seconds = 0.obs;
//   CaseAlertModel? caseAlert;

//   void startTimer(CaseAlertModel caseAlert) {
//     timer = Timer.periodic(
//       const Duration(seconds: 1),
//       (timer) async {
//         seconds.value += 1;
//         if (seconds.value == 45) {
//           timer.cancel();
//           await FireStoreCaseAlert()
//               .updateCaseAlertInfo(
//             key: 'alertType',
//             value: 'timerSend',
//             caseAlertModel: caseAlert,
//           )
//               .then((value) {
//             Get.snackbar(
//               'Send to Security',
//               'The Alert sended to security company',
//               snackPosition: SnackPosition.TOP,
//             );
//           });
//         }
//       },
//     );
//   }

//   void stopTimer() {
//     if (timer != null) {
//       timer!.cancel();
//       seconds.value = 0;
//     }
//   }

//   void createMemberWithEmailAndPassword({
//     int? index,
//     String image = '',
//     String faceId = '',
//   }) async {
//     try {
//       manageFaces.value = true;
//       await _auth
//           .createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//           .then((user) async {
//         memberId = user.user!.uid;
//         userData!.membersId!.add(memberId);

//         MemberModel member = MemberModel(
//           memberId: memberId,
//           userId: AppConstants.userId,
//           email: email,
//           firstName: firstName,
//           lastName: lastName,
//           image: image,
//           cameraId: userData!.cameraId,
//           faceId: faceId,
//         );
//         await FireStoreMember()
//             .addMemberToFirestore(member)
//             .then((value) async {
//           await FireStoreUser().updateUserInfo(
//             key: 'membersId',
//             value: userData!.membersId,
//             userModel: userData!,
//           );
//           await FireStoreUser().updateUserInfo(
//             key: 'numberFamilyMembers',
//             value: userData!.membersId!.length,
//             userModel: userData!,
//           );
//           await FireStoreCamera().updateFaceWithUserId(
//             cameraId: userData!.cameraId!,
//             doc: faceId,
//             value: memberId,
//           );
//           Get.snackbar(
//             'Successfully',
//             'Create Member Successfully',
//             snackPosition: SnackPosition.TOP,
//             colorText: Colors.green,
//           );
//           manageFaces.value = false;
//           if (index != null) {
//             if (index != userData!.numberFamilyMembers) {
//               pageController.jumpToPage(index);
//             } else {
//               userData!.membersId!.forEach((String element) {
//                 getMembers(element);
//               });
//               Get.off(() => const HomeView());
//             }
//           }
//         });
//         return user;
//       });
//     } catch (e) {
//       Get.snackbar(
//         'Error Add Member',
//         e.toString(),
//       );
//     }
//   }

//   // Manage Faces Screen
//   List<MemberModel> members = [];
//   Future<void> getMembers(String mid) async {
//     return await FireStoreMember().getCurrentMember(mid).then(
//       (value) {
//         var member =
//             MemberModel.fromJson(value.data() as Map<dynamic, dynamic>?);
//         members.add(member);
//       },
//     );
//   }

//   // Manage Faces Handling
//   RxBool manageFaces = false.obs;
//   Future<void> handleManageFaces(
//     String value,
//     String face,
//     String id,
//   ) async {
//     manageFaces.value = true;
//     if (value == 'addToOwner') {
//       await addFaceToOwner(face, id).then((value) async {
//         await getUser();
//         await FireStoreCamera()
//             .updateFaceWithUserId(
//           cameraId: userData!.cameraId!,
//           doc: id,
//           value: userData!.userId!,
//         )
//             .then((value) {
//           Get.dialog(
//             CupertinoAlertDialog(
//               title: const Text('Success'),
//               content: const Text('Change Image for Owner'),
//               actions: [
//                 CupertinoButton(
//                   onPressed: () {
//                     Get.back();
//                     manageFaces.value = false;
//                   },
//                   child: const Text('Ok'),
//                 ),
//               ],
//             ),
//           );
//         });
//       });
//     } else if (value == 'addToMember') {
//       Get.to(
//         () => AddMembersWithFaceView(
//           imageUrl: face,
//           faceId: id,
//         ),
//       );
//     } else if (value == 'editToMember') {
//       Get.to(
//         () => EditMembersWithFaceView(
//           imageUrl: face,
//           faceId: id,
//         ),
//       );
//       manageFaces.value = false;
//     } else if (value == 'deleteIntruder') {
//       await FireStoreCamera().deleteIntruderById(
//         cameraId: userData!.cameraId!,
//         faceId: id,
//       );
//       manageFaces.value = false;
//     } else {
//       manageFaces.value = false;
//       previewFace(face);
//     }
//   }

//   Future<void> addFaceToOwner(String imageUrl, String faceId) async {
//     return await FireStoreUser()
//         .updateUserInfo(
//       key: 'image',
//       value: imageUrl,
//       userModel: userData!,
//     )
//         .then((value) async {
//       await FireStoreUser().updateUserInfo(
//         key: 'faceId',
//         value: faceId,
//         userModel: userData!,
//       );
//     });
//   }

//   Future<void> addFaceToMember(String imageUrl) async {}

//   deleteFace() {}

//   previewFace(String image) {
//     Get.dialog(
//       AlertDialog(
//         title: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: const Icon(
//                   Icons.close,
//                   color: Color(0xFFC8D1E1),
//                 ),
//               ),
//             ),
//             Text(
//               'Face Image',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Montserrat',
//                 fontSize: Dimensions.font16,
//                 fontWeight: FontWeight.w600,
//                 height: 1.8,
//               ),
//             ),
//           ],
//         ),
//         content: SizedBox(
//           width: Dimensions.heightHalf,
//           child: Image.network(
//             image,
//             fit: BoxFit.contain,
//             width: Dimensions.heightHalf,
//           ),
//         ),
//       ),
//     );
//   }

//   // Delete Member
//   deleteMember(MemberModel member) async {
//     manageFaces.value = true;

//     await FireStoreCamera()
//         .deleteFaceById(
//       cameraId: member.cameraId!,
//       faceId: member.faceId!,
//     )
//         .then((value) async {
//       userData!.numberFamilyMembers = userData!.numberFamilyMembers! - 1;
//       userData!.membersId!.removeWhere((element) => element == member.memberId);
//       await FireStoreUser().updateUserInfo(
//         key: 'membersId',
//         value: userData!.membersId,
//         userModel: userData!,
//       );
//       await FireStoreUser().updateUserInfo(
//         key: 'numberFamilyMembers',
//         value: userData!.numberFamilyMembers,
//         userModel: userData!,
//       );
//     });
//     await FireStoreMember().deleteMember(member.memberId!).then((value) {
//       manageFaces.value = false;
//       Get.snackbar(
//         'Successfully',
//         'Delete Member Successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         colorText: Colors.green,
//       );
//     });
//   }

//   // Security which detect locaion
//   LocationData? locationData;
//   var markers = RxSet<Marker>();
//   var isLoading = false.obs;
//   var longitude = 0.0.obs;
//   var latitude = 0.0.obs;

//   fetchLocation({
//     required double long,
//     required double lat,
//   }) async {
//     try {
//       isLoading(true);
//       longitude.value = long;
//       latitude.value = lat;
//     } catch (e) {
//       Get.snackbar(
//         'Error while getting data',
//         e.toString(),
//         snackPosition: SnackPosition.TOP,
//         colorText: Colors.red,
//       );
//     } finally {
//       isLoading(false);
//       createMarkers();
//     }
//   }

//   createMarkers() {
//     markers.add(
//       Marker(
//         markerId: const MarkerId('Location'),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         position: LatLng(latitude.value, longitude.value),
//         onTap: () {},
//       ),
//     );
//   }
// }