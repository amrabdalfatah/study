import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/app.dart';
import 'package:study_academy/core/services/firestore/firestore_course.dart';
import 'package:study_academy/core/services/firestore/firestore_doctor.dart';
import 'package:study_academy/core/services/storage/course_storage.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/doctor/chat_screen.dart';
import 'package:study_academy/features/doctor/course_screen.dart';
import 'package:study_academy/features/doctor/home_screen.dart';
import 'package:study_academy/features/doctor/profile_screen.dart';
import 'package:study_academy/model/course_model.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/model/lesson_model.dart';
import 'package:uuid/uuid.dart';

// ahmed26@study.academy
// A111111

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
  ValueNotifier<bool> dataLoaded = ValueNotifier(true);
  ValueNotifier<int> screenIndex = ValueNotifier(0);
  String title = '', description = '', price = '', categoryId = '';
  RxString? imageCourse = ''.obs;
  RxString? categoryName = ''.obs;
  XFile? mediaFile;
  final ImagePicker _picker = ImagePicker();
  CourseModel? courseModel;
  String lessonTitle = '', lessonDescription = '', lessonVideoUrl = '';
  LessonModel? lessonModel;

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

  void setImageUrl() {
    imageCourse = ''.obs;
  }

  // ahmed26@study.academy
  // A111111

  Uint8List? uploadedImage;

  Future<void> onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) {},
          allowedExtensions: ['png', 'jpg', 'jpeg'],
        );
        if (result != null) {
          imageCourse!.value = result.xFiles.first.path;
          uploadedImage = result.files.single.bytes;
        }
      } else {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        mediaFile = pickedFile;
        imageCourse!.value = mediaFile!.path;
      }
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  void setCategoryId(String catId, String catTitle) {
    categoryId = catId;
    categoryName!.value = catTitle;
  }

  void addCourse() async {
    action.value = true;
    try {
      final imagePath = kIsWeb
          ? await CourseStorage().uploadCourseImageWeb(
              uploadedImage,
              title,
            )
          : await CourseStorage().uploadCourseImage(
              imageCourse!.value,
              title,
            );
      const uuid = Uuid();
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

  void addLesson(BuildContext context, String coId) async {
    action.value = true;
    try {
      const uuid = Uuid();
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
    Get.offAll(() => Controller().mainScreen);
  }
}
