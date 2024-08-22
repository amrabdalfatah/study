import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/services/firestore/firestore_admin.dart';
import 'package:study_academy/core/services/firestore/firestore_category.dart';
import 'package:study_academy/core/services/firestore/firestore_course.dart';
import 'package:study_academy/core/services/firestore/firestore_doctor.dart';
import 'package:study_academy/core/services/firestore/firestore_student.dart';
import 'package:study_academy/core/services/storage/category_storage.dart';
import 'package:study_academy/core/services/storage/doctor_storage.dart';
import 'package:study_academy/core/services/storage/student_storage.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/features/admin/admin_homeview.dart';
import 'package:study_academy/features/admin/chat_screen.dart';
import 'package:study_academy/features/admin/course_screen.dart';
import 'package:study_academy/features/admin/doctor_screen.dart';
import 'package:study_academy/features/admin/home_screen.dart';
import 'package:study_academy/features/admin/student_screen.dart';
import 'package:study_academy/features/splash/splash_view.dart';
import 'package:study_academy/model/admin_model.dart';
import 'package:study_academy/model/category_model.dart';
import 'package:study_academy/model/doctor_model.dart';
import 'package:study_academy/model/student_model.dart';
import 'package:uuid/uuid.dart';

class AdminViewModel extends GetxController {
  AdminModel? adminData;
  List<Widget> screens = [
    const HomeScreen(),
    const DoctorScreen(),
    CourseScreen(),
    const StudentScreen(),
    const ChatScreen(),
  ];
  RxBool shownPassword = true.obs;
  RxBool action = false.obs;
  DoctorModel? doctorModel;
  StudentModel? studentModel;

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

  void acceptCourse(
      String courseId, String courseName, String image, String doctorId) async {
    action.value = true;
    try {
      await FireStoreCourse().updateCourseInfo(
        key: 'active',
        value: true,
        courseId: courseId,
      );
      await FirebaseFirestore.instance.collection('Rooms').doc(courseId).set({
        'name': courseName,
        'image': image,
        'roomId': courseId,
      });
      await FirebaseFirestore.instance
          .collection('Rooms')
          .doc(courseId)
          .collection('People')
          .add({
        'id': AppConstants.userId,
      });
      await FirebaseFirestore.instance
          .collection('Rooms')
          .doc(courseId)
          .collection('People')
          .add({
        'id': doctorId,
      });
      Get.snackbar(
        'Success',
        'Added New Chat for this Course',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
    action.value = false;
    update();
  }

  void changeShownPassword() {
    shownPassword.value = !shownPassword.value;
  }

  String email = '',
      password = '',
      fullName = '',
      code = '',
      phone = '',
      id = '';
  RxString? imageUrl = ''.obs;
  void setImageUrl() {
    imageUrl = ''.obs;
    update();
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

  void addDoctor() async {
    action.value = true;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((user) async {
        id = user.user!.uid;
        final imagePath = await DoctorStorage().uploadDoctorImage(
          imageUrl!.value,
          email,
        );
        doctorModel = DoctorModel(
          doctorId: id,
          email: email,
          password: password,
          fullName: fullName,
          image: imagePath,
          phone: phone,
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
      imageUrl = ''.obs;
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
    imageUrl = ''.obs;
    update();
  }

  void addStudent() async {
    action.value = true;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((user) async {
        id = user.user!.uid;
        final imagePath = await StudentStorage().uploadStudentImage(
          imageUrl!.value,
          email,
        );
        studentModel = StudentModel(
          studentId: id,
          email: email,
          password: password,
          fullName: fullName,
          code: code,
          image: imagePath,
          phone: phone,
          deviceId: '',
        );
        await FireStoreStudent()
            .addStudentToFirestore(studentModel!)
            .then((value) async {
          Get.snackbar(
            'Successfully',
            'Create Student Successfully',
            snackPosition: SnackPosition.TOP,
            colorText: Colors.green,
          );
        });
      });

      action.value = false;
      imageUrl = ''.obs;
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
    imageUrl = ''.obs;
    update();
  }

  // ---------------------------------------------------------------------
  // Add Category
  RxString? imageCat = ''.obs;
  void setImageCat() {
    imageCat = ''.obs;
    update();
  }

  void _setImageCatFileFromFile(XFile? value) {
    mediaFile = value;
    imageCat!.value = mediaFile!.path;
    update();
  }

  Future<void> onImageCatButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
        );
        _setImageCatFileFromFile(pickedFile);
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

  RxInt catIndex = 0.obs;
  void changeCat(int index) {
    catIndex.value = index;
    update();
  }

  String catTitle = '';
  CategoryModel? categoryModel;
  void addCategory(BuildContext context) async {
    action.value = true;
    try {
      final imagePath = await CategoryStorage().uploadCategoryImage(
        imageCat!.value,
        catTitle,
      );
      final uuid = Uuid();
      final catId = uuid.v4();

      categoryModel = CategoryModel(
        categoryId: catId,
        title: catTitle,
        image: imagePath,
      );
      await FireStoreCategory()
          .addCategoryToFirestore(categoryModel!)
          .then((value) async {
        Get.snackbar(
          'Successfully',
          'Create Category Successfully',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.green,
        );
      });
      action.value = false;
      imageCat = ''.obs;
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
    imageCat = ''.obs;
    update();
  }

  registerCourseToStudent(
      String courseId, String studentId, bool isRegistered) async {
    action.value = true;
    final uuid = Uuid();
    final regId = uuid.v4();
    if (!isRegistered) {
      try {
        await FirebaseFirestore.instance
            .collection('Registers')
            .doc(regId)
            .set({
          'courseId': courseId,
          'studentId': studentId,
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
        );
      }
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
}
