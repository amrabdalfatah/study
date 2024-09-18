// import 'dart:async';
// import 'dart:io';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:study_academy/core/cubit/record_state.dart' as state;
// import 'package:study_academy/core/utils/constants.dart';

// class RecordCubit extends Cubit<state.RecordState> {
//   RecordCubit() : super(state.RecordInitial());

//   AudioRecorder _audioRecorder = AudioRecorder();

//   void startRecording() async {
//     Map<Permission, PermissionStatus> permissions = await [
//       Permission.storage,
//       Permission.microphone,
//     ].request();

//     bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
//         permissions[Permission.microphone]!.isGranted;

//     if (permissionsGranted) {
//       Directory appFolder = Directory(Paths.recording);
//       bool appFolderExists = await appFolder.exists();
//       if (!appFolderExists) {
//         final created = await appFolder.create(recursive: true);
//         print(created.path);
//       }

//       final filepath = Paths.recording +
//           '/' +
//           DateTime.now().millisecondsSinceEpoch.toString() +
//           '.rn';
//       print(filepath);

//       final config = RecordConfig();

//       await _audioRecorder.start(config, path: filepath);

//       emit(state.RecordOn());
//     } else {
//       print('Permissions not granted');
//     }
//   }

//   void stopRecording() async {
//     String? path = await _audioRecorder.stop();
//     emit(state.RecordStopped());
//     print('Output path $path');
//   }

//   Stream<double> aplitudeStream() async* {
//     while (true) {
//       await Future.delayed(Duration(milliseconds: 100));
//       final ap = await _audioRecorder.getAmplitude();
//       yield ap.current;
//     }
//   }
// }
