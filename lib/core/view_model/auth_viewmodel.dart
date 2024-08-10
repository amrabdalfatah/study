
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class AuthViewModel extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final LocalStorageData localStorageData = Get.find();
//   String countryKey = '+965'; // +965 Kw
//   var shownPassword = true.obs;
//   var action = false.obs;
//   String email = '', password = '', firstName = '', lastName = '';
//   String confirmPassword = '';
//   String phone = '';
//   String userId = '';
//   var isVerified = false.obs;
//   var month = ''.obs;
//   var day = 0.obs;
//   var year = 1950.obs;
//   var agreeTerms = false.obs;
//   String cameraName = '';
//   String securityCompany = 'AlYamamaHome - 3KD/month';
//   int numberFamilyMembers = 0;
//   int trainingHours = 0;
//   // for Scan QR and check Internet
//   String scanBarcode = 'Unknown';
//   Connectivity connectivity = Connectivity();

//   // Method to scan qr
//   Future<void> scanQR() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666',
//         'Cancel',
//         false,
//         ScanMode.QR,
//       );
//       scanBarcode = barcodeScanRes;
//       AppConstants.cameraId = scanBarcode;
//       CameraModel? cameraModel;
//       await FireStoreCamera().getCurrentCamera(scanBarcode).then((value) {
//         cameraModel =
//             CameraModel.fromJson(value.data() as Map<String, dynamic>);
//       });

//       if (cameraModel!.userId!.isNotEmpty) {
//         Get.snackbar(
//           'Camera Attention',
//           'This camera is registered to its owner \ntry another camera',
//           snackPosition: SnackPosition.TOP,
//         );
//         Get.off(() => LoginView());
//       } else {
//         Get.snackbar(
//           'QR Code',
//           'Camera Code: $scanBarcode',
//           snackPosition: SnackPosition.TOP,
//         );
//         Get.to(() => RegisterEmailPasswordView());
//       }
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     update();
//   }

//   // This method to change Password from visible to un_visible
//   void changeShownPassword() {
//     shownPassword.value = !shownPassword.value;
//   }

//   // Method to check for agree terms or not
//   void changeAgreeTerms() {
//     agreeTerms.value = !agreeTerms.value;
//   }

//   // Method to change Month
//   void selectMonth(String val) {
//     month.value = val;
//   }

//   // Method to change Day
//   void selectDay(int val) {
//     day.value = val;
//   }

//   // Method to change Year
//   void selectYear(int val) {
//     year.value = val;
//   }

//   // Method to sign with email and password
//   void signInWithEmailAndPassword() async {
//     action.value = true;
//     try {
//       await _auth
//           .signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//           .then((value) async {
//         AppConstants.loginId = value.user!.uid;
//         if (await FireStoreUser().checkUser(value.user!.uid)) {
//           AppConstants.typePerson = TypePerson.owner;
//           if (value.user!.emailVerified) {
//             AppConstants.userId = value.user!.uid;
//             UserModel? userData;
//             await FireStoreUser().getCurrentUser(value.user!.uid).then((value) {
//               userData =
//                   UserModel.fromJson(value.data() as Map<dynamic, dynamic>?);
//             }).whenComplete(() async {
//               if (userData!.isVerified!) {
//                 action.value = false;
//                 Get.to(() => const HomeView());
//                 // Get.to(() => const FaceAuthenticateView());
//               } else {
//                 // await IntrudersStorage().deleteStorage().whenComplete(() async {
//                 //   print('deleted storage');
//                 //   await FireStoreCamera()
//                 //       .deleteFaces(userData!.cameraId!)
//                 //       .whenComplete(() async {
//                 //     print('delete faces');
//                 //     await FireStoreCamera()
//                 //         .deleteIntruders(userData!.cameraId!);
//                 //   });
//                 // });
//                 await FireStoreUser()
//                     .updateUserInfo(
//                   userModel: userData!,
//                   key: 'isVerified',
//                   value: true,
//                 )
//                     .then((value) async {
//                   await FireStoreCamera().updateSettingsCamera(
//                     key: 'finished',
//                     value: false,
//                     cameraId: userData!.cameraId!,
//                     document: 'training_results',
//                   );
//                 });
//                 action.value = false;
//                 Get.to(() => const HomeView());
//                 // Get.to(() => const FaceAuthenticateView());
//               }
//             });
//           } else {
//             action.value = false;
//             Get.snackbar(
//               'Verify',
//               'Please Verify your email via going to inbox and verify it',
//               snackPosition: SnackPosition.BOTTOM,
//               colorText: Colors.deepOrange,
//             );
//           }
//         } else if (await FireStoreMember().checkMember(value.user!.uid)) {
//           AppConstants.typePerson = TypePerson.member;
//           action.value = false;
//           Get.offAll(() => const HomeView());
//         } else {
//           AppConstants.typePerson = TypePerson.securityCompany;
//           action.value = false;
//           Get.offAll(() => const SecurityPage());
//         }
//       });
//     } catch (e) {
//       action.value = false;
//       Get.snackbar(
//         'Error Login',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         colorText: Colors.red,
//       );
//     }
//   }

//   // Method to register user with automatic setup
//   void createAccountWithEmailAndPasswordAutomaticSetup() async {
//     action.value = true;
//     try {
//       await _auth
//           .createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//           .then((user) async {
//         userId = user.user!.uid;

//         UserModel userModel = UserModel(
//           userId: userId,
//           email: email,
//           phone: '$countryKey$phone',
//           firstName: firstName,
//           lastName: lastName,
//           image: '',
//           cameraName: 'My-Yamama',
//           dateOfBirth: '${month.value}, ${day.value}, ${year.value}',
//           address: {
//             'Latitude': latitude.value,
//             'Longitude': longitude.value,
//           },
//           cameraId: AppConstants.cameraId,
//           securityCompany: securityCompany,
//           numberFamilyMembers: 0,
//           trainingHours: 30,
//           isVerified: user.user!.emailVerified,
//           membersId: [],
//           faceId: '',
//           report: 3,
//         );
//         await FireStoreUser().addUserToFirestore(userModel).then((value) {
//           action.value = false;
//           Get.snackbar(
//             'Successfully',
//             'Create User Successfully, \nYou can now verify your email first and then login',
//             snackPosition: SnackPosition.TOP,
//             colorText: Colors.green,
//           );
//         });
//         await FireStoreCaseAlert().startCaseAlert(
//           cameraId: AppConstants.cameraId!,
//           userId: userId,
//         );
//         await FireStoreCamera().updateCamera(
//           cameraId: AppConstants.cameraId!,
//           key: 'userId',
//           value: userId,
//         );

//         await FireStoreCamera().updateSettingsCamera(
//           key: 'mode',
//           value: 'Automatic',
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'training_time',
//           value: 30,
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'num_faces',
//           value: 1,
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'required_num_faces',
//           value: 1,
//           cameraId: AppConstants.cameraId!,
//           document: 'training_results',
//         );
//         await user.user!.sendEmailVerification();
//         return user;
//       });
//     } catch (e) {
//       action.value = false;
//       Get.snackbar(
//         'Error Register',
//         e.toString(),
//       );
//     }
//   }

//   Future<void> createAccountWithEmailAndPassword() async {
//     action.value = true;
//     try {
//       action.value = true;
//       await _auth
//           .createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//           .then((user) async {
//         userId = user.user!.uid;
//         UserModel userModel = UserModel(
//           userId: userId,
//           email: email,
//           phone: '$countryKey$phone',
//           firstName: firstName,
//           lastName: lastName,
//           image: '',
//           cameraName: cameraName,
//           dateOfBirth: '${month.value}, ${day.value}, ${year.value}',
//           address: {
//             'Latitude': latitude.value,
//             'Longitude': longitude.value,
//           },
//           cameraId: AppConstants.cameraId,
//           securityCompany: securityCompany,
//           numberFamilyMembers: numberFamilyMembers,
//           trainingHours: trainingHours,
//           isVerified: user.user!.emailVerified,
//           membersId: [],
//           faceId: '',
//           report: 3,
//         );
//         await FireStoreUser().addUserToFirestore(userModel).then((value) {
//           action.value = false;
//           Get.snackbar(
//             'Successfully',
//             'Create User Successfully, \nYou can now verify your email first and then login',
//             snackPosition: SnackPosition.TOP,
//             colorText: Colors.green,
//           );
//         });
//         await FireStoreCaseAlert().startCaseAlert(
//           cameraId: AppConstants.cameraId!,
//           userId: userId,
//         );
//         await FireStoreCamera().updateCamera(
//           cameraId: AppConstants.cameraId!,
//           key: 'userId',
//           value: userId,
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'mode',
//           value: 'manual',
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'num_faces',
//           value: numberFamilyMembers + 1,
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'training_time',
//           value: trainingHours,
//           cameraId: AppConstants.cameraId!,
//           document: 'training',
//         );
//         await FireStoreCamera().updateSettingsCamera(
//           key: 'required_num_faces',
//           value: numberFamilyMembers + 1,
//           cameraId: AppConstants.cameraId!,
//           document: 'training_results',
//         );
//         action.value = false;
//         await user.user!.sendEmailVerification();
//         return user;
//       });
//     } catch (e) {
//       action.value = false;
//       Get.snackbar(
//         'Error Register',
//         e.toString(),
//       );
//     }
//   }

//   String emailPasswordReset = '';

//   void forgetPassword() async {
//     await _auth.sendPasswordResetEmail(email: emailPasswordReset);
//   }

//   // Map Controller
//   LocationData? locationData;
//   var markers = RxSet<Marker>();
//   var isLoading = false.obs;
//   var longitude = 0.0.obs;
//   var latitude = 0.0.obs;

//   fetchLocation() async {
//     try {
//       isLoading(true);
//       locationData = await getLocationData();
//       longitude.value = locationData!.longitude!;
//       latitude.value = locationData!.latitude!;
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

//   getLocationData() async {
//     Location location = Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (serviceEnabled) {
//         return;
//       }
//     }
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     locationData = await location.getLocation();
//     return locationData;
//   }
// }