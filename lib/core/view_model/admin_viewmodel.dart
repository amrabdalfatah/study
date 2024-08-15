import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/services/doctor_storage.dart';
import 'package:study_academy/core/services/firestore_admin.dart';
import 'package:study_academy/core/services/firestore_doctor.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/admin/chat_screen.dart';
import 'package:study_academy/features/admin/course_screen.dart';
import 'package:study_academy/features/admin/doctor_screen.dart';
import 'package:study_academy/features/admin/home_screen.dart';
import 'package:study_academy/features/admin/student_screen.dart';
import 'package:study_academy/model/admin_model.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/routes.dart';

class AdminViewModel extends GetxController {
  AdminModel? adminData;
  List<Widget> screens = [
    const HomeScreen(),
    DoctorScreen(),
    const CourseScreen(),
    const StudentScreen(),
    const ChatScreen(),
  ];
  RxBool shownPassword = true.obs;
  RxBool action = false.obs;
  DoctorModel? doctorModel;

//   Stream<QuerySnapshot>? cameraSettings;
//   CameraModel cameraModel = CameraModel();
//   // List<CameraFace> cameraFaces = [];
  ValueNotifier<bool> dataLoaded = ValueNotifier(true);
  ValueNotifier<int> screenIndex = ValueNotifier(0);

  @override
  void onInit() {
    super.onInit();
    getAdmin();
  }

  Future<void> getAdmin() async {
    dataLoaded.value = false;
    await FireStoreAdmin().getCurrentUser(AppConstants.userId!).then((value) {
      adminData = AdminModel.fromJson(value.data() as Map<dynamic, dynamic>?);
    }).whenComplete(
      () {},
    );
    dataLoaded.value = true;
    update();
  }

  void changeScreen(int selected) {
    screenIndex.value = selected;
    update();
  }

  void changeShownPassword() {
    shownPassword.value = !shownPassword.value;
  }

  String doctorEmail = '',
      doctorPassword = '',
      doctorFirstName = '',
      doctorLastName = '',
      doctorPhone = '',
      doctorId = '';
  RxString? imageDoctorUrl = ''.obs;
  // Select Image for Doctor
  XFile? mediaFile;
  final ImagePicker _picker = ImagePicker();
  void _setImageFileFromFile(XFile? value) {
    mediaFile = value;
    imageDoctorUrl!.value = mediaFile!.path;
    update();
  }

  Future<void> onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        _setImageFileFromFile(pickedFile);
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
        );
      }
    }
  }

  void addDoctor() async {
    action.value = true;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: doctorEmail,
        password: doctorPassword,
      )
          .then((user) async {
        doctorId = user.user!.uid;
        final imagePath = await DoctorStorage().uploadDoctorImage(
          imageDoctorUrl!.value,
          doctorEmail,
        );
        doctorModel = DoctorModel(
          doctorId: doctorId,
          email: doctorEmail,
          firstName: doctorFirstName,
          lastName: doctorLastName,
          image: imagePath,
          phone: doctorPhone,
        );
        await FireStoreDoctor()
            .addDoctorToFirestore(doctorModel!)
            .then((value) async {
          Get.snackbar(
            'Successfully',
            'Create Doctor Successfully',
            snackPosition: SnackPosition.TOP,
            colorText: Colors.green,
          );
        });
      });

      action.value = false;
      update();
      Get.off(() => const AdminHomeView());
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
    action.value = false;
    update();
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.loginRoute);
  }

//   // Add Members Screen
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
}
