// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';

// class LocalAuth {
//   static final _auth = LocalAuthentication();

//   static Future<bool> _canAuthenticate() async =>
//       await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

//   static Future<bool> authenticate() async {
//     try {
//       if (!await _canAuthenticate()) return false;

//       return await _auth.authenticate(
//         localizedReason: 'Use Face Id to authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'There is error $e');
//       return false;
//     }
//   }
// }