import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/services/firestore/firestore_course.dart';
import 'package:study_academy/core/services/firestore/firestore_doctor.dart';
import 'package:study_academy/core/services/storage/course_storage.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/doctor/chat_screen.dart';
import 'package:study_academy/features/doctor/course_screen.dart';
import 'package:study_academy/features/doctor/home_screen.dart';
import 'package:study_academy/features/doctor/profile_screen.dart';
import 'package:study_academy/features/splash/splash_view.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/model/lesson_model.dart';
import 'package:uuid/uuid.dart';

class DoctorViewModel extends GetxController {
  DoctorModel? doctorData;
  List<Widget> screens = [
    const HomeScreen(),
    CourseScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];
  List<String> appBars = [
    'Home',
    'Add Course',
    'Chat Room',
    'Profile',
  ];
  RxBool action = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDoctor();
  }

  ValueNotifier<bool> dataLoaded = ValueNotifier(true);
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

  ValueNotifier<int> screenIndex = ValueNotifier(0);
  void changeScreen(int selected) {
    screenIndex.value = selected;
    update();
  }

  String title = '', description = '', price = '', categoryId = '';

  RxString? imageCourse = ''.obs;
  RxString? categoryName = ''.obs;
  void setImageUrl() {
    imageCourse = ''.obs;
  }

  XFile? mediaFile;
  final ImagePicker _picker = ImagePicker();
  void _setImageFileFromFile(XFile? value) {
    mediaFile = value;
    imageCourse!.value = mediaFile!.path;
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

  void setCategoryId(String catId, String catTitle) {
    categoryId = catId;
    categoryName!.value = catTitle;
  }

  CourseModel? courseModel;
  void addCourse() async {
    action.value = true;
    try {
      final imagePath = await CourseStorage().uploadCourseImage(
        imageCourse!.value,
        title,
      );
      final uuid = Uuid();
      final courseId = uuid.v4();

      courseModel = CourseModel(
        courseId: courseId,
        categoryId: categoryId,
        doctorId: AppConstants.userId,
        title: title,
        description: description,
        image: imagePath,
        price: double.parse(price),
      );

      await FireStoreCourse()
          .addCourseToFirestore(courseModel!)
          .then((value) async {
        Get.snackbar(
          'Successfully',
          'Create Course Successfully',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );
      });

      action.value = false;
      imageCourse = ''.obs;
      screenIndex.value = 0;
      update();
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
    action.value = false;
    imageCourse = ''.obs;
    update();
  }

  String lessonTitle = '', lessonDescription = '', lessonVideoUrl = '';
  LessonModel? lessonModel;
  void addLesson(BuildContext context, String coId) async {
    action.value = true;
    try {
      final uuid = Uuid();
      final lessonId = uuid.v4();

      lessonModel = LessonModel(
        lessonId: lessonId,
        title: lessonTitle,
        description: lessonDescription,
        pathFile: lessonVideoUrl,
      );

      await FireStoreCourse()
          .addLessonToCourse(coId, lessonModel!)
          .then((value) async {
        Get.snackbar(
          'Successfully',
          'Create Lesson Successfully',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );
      });

      action.value = false;
      update();
      Navigator.of(context).pop();
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
