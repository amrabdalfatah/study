import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/services/firestore_doctor.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/doctor/chat_screen.dart';
import 'package:study_academy/features/doctor/course_screen.dart';
import 'package:study_academy/features/doctor/home_screen.dart';
import 'package:study_academy/features/doctor/profile_screen.dart';
import 'package:study_academy/features/splash/splash_view.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/model/student_model.dart';

class DoctorViewModel extends GetxController {
  DoctorModel? doctorData;
  List<Widget> screens = [
    const HomeScreen(),
    CourseScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];
  RxBool action = false.obs;
  StudentModel? studentModel;

  ValueNotifier<bool> dataLoaded = ValueNotifier(true);
  ValueNotifier<int> screenIndex = ValueNotifier(0);

  @override
  void onInit() {
    super.onInit();
    getDoctor();
  }

  Future<void> getDoctor() async {
    dataLoaded.value = false;
    await FireStoreDoctor()
        .getCurrentDoctor(AppConstants.userId!)
        .then((value) {
      doctorData = DoctorModel.fromJson(value.data() as Map<dynamic, dynamic>?);
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

  String title = '',
      description = '',
      firstName = '',
      lastName = '',
      price = '',
      id = '';
  RxString? imageUrl = ''.obs;
  void setImageUrl() {
    imageUrl = ''.obs;
  }

  // Select Image for Doctor
  XFile? mediaFile;
  final ImagePicker _picker = ImagePicker();
  void _setImageFileFromFile(XFile? value) {
    mediaFile = value;
    imageUrl!.value = mediaFile!.path;
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

  // void addDoctor() async {
  //   action.value = true;
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   try {
  //     await _auth
  //         .createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     )
  //         .then((user) async {
  //       id = user.user!.uid;
  //       final imagePath = await DoctorStorage().uploadDoctorImage(
  //         imageUrl!.value,
  //         email,
  //       );
  //       doctorModel = DoctorModel(
  //         doctorId: id,
  //         email: email,
  //         firstName: firstName,
  //         lastName: lastName,
  //         image: imagePath,
  //         phone: phone,
  //       );
  //       await FireStoreDoctor()
  //           .addDoctorToFirestore(doctorModel!)
  //           .then((value) async {
  //         Get.snackbar(
  //           'Successfully',
  //           'Create Doctor Successfully',
  //           snackPosition: SnackPosition.TOP,
  //           colorText: Colors.green,
  //         );
  //       });
  //     });
  //
  //     action.value = false;
  //     imageUrl = ''.obs;
  //     update();
  //     Get.off(() => const AdminHomeView());
  //   } catch (error) {
  //     Get.snackbar(
  //       'Error',
  //       error.toString(),
  //       snackPosition: SnackPosition.TOP,
  //       colorText: Colors.red,
  //     );
  //   }
  //   action.value = false;
  //   imageUrl = ''.obs;
  //   update();
  // }
  //
  // void addStudent() async {
  //   action.value = true;
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   try {
  //     await _auth
  //         .createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     )
  //         .then((user) async {
  //       id = user.user!.uid;
  //       final imagePath = await StudentStorage().uploadStudentImage(
  //         imageUrl!.value,
  //         email,
  //       );
  //       studentModel = StudentModel(
  //         studentId: id,
  //         email: email,
  //         firstName: firstName,
  //         lastName: lastName,
  //         image: imagePath,
  //         phone: phone,
  //         courses: [],
  //       );
  //       await FireStoreStudent()
  //           .addStudentToFirestore(studentModel!)
  //           .then((value) async {
  //         Get.snackbar(
  //           'Successfully',
  //           'Create Student Successfully',
  //           snackPosition: SnackPosition.TOP,
  //           colorText: Colors.green,
  //         );
  //       });
  //     });
  //
  //     action.value = false;
  //     imageUrl = ''.obs;
  //     update();
  //     Get.off(() => const AdminHomeView());
  //   } catch (error) {
  //     Get.snackbar(
  //       'Error',
  //       error.toString(),
  //       snackPosition: SnackPosition.TOP,
  //       colorText: Colors.red,
  //     );
  //   }
  //   action.value = false;
  //   imageUrl = ''.obs;
  //   update();
  // }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    final box = GetStorage();
    box.remove('userid');
    box.remove('usertype');
    Get.offAll(() => const SplashView());
  }

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
}
