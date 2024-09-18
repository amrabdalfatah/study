import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:uuid/uuid.dart';

class NewMessage extends StatefulWidget {
  final String roomId;
  const NewMessage({
    super.key,
    required this.roomId,
  });

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final uuid = Uuid().v4();

    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .collection('Chat')
        .doc(uuid)
        .set({
      'text': enteredMessage,
      'type': 'text',
      'id': uuid,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userCode': AppConstants.userCode,
    });
  }

  XFile? fileChat;
  Uint8List? uploadedFile;

  _selectedFile() async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: ['png', 'jpg', 'jpeg'],
        );
        if (result != null) {
          fileChat = result.xFiles.first;
          uploadedFile = result.files.single.bytes;
        }
      } else {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        fileChat = pickedFile!;
      }
      setState(() {});
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  _sendFile() async {
    await _selectedFile();
    if (fileChat!.path.isEmpty) {
      return;
    }
    setState(() {
      uploading = true;
    });
    const uuid = Uuid();
    final key = uuid.v4();

    await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .putFile(
          File(fileChat!.path),
        );

    final fileUrl = await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .getDownloadURL();

    final user = FirebaseAuth.instance.currentUser!;
    final uid = Uuid().v4();
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .collection('Chat')
        .doc(uid)
        .set({
      'text': fileUrl,
      'type': 'image',
      'id': uid,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userCode': AppConstants.userCode,
    }).whenComplete(() {
      setState(() {
        uploading = false;
      });
    });
  }

//   Future<String?> _recordAudio() async {
//     // Check and request permission if needed
//     if (await record.hasPermission()) {
//       // Start recording to file
//       await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
//     }

// // Stop recording...
//     final path = await record.stop();
//     return path;
//   }

  // _sendAudio() async {
  //   await _recordAudio().then((value) async {
  //     setState(() {
  //       uploading = true;
  //     });
  //     const uuid = Uuid();
  //     final key = uuid.v4();

  //     await FirebaseStorage.instance
  //         .ref()
  //         .child('chats/${widget.roomId}/$key')
  //         .putFile(
  //           File(value!),
  //         );
  //     final fileUrl = await FirebaseStorage.instance
  //         .ref()
  //         .child('chats/${widget.roomId}/$key')
  //         .getDownloadURL();

  //     final user = FirebaseAuth.instance.currentUser!;
  //     await FirebaseFirestore.instance
  //         .collection('Rooms')
  //         .doc(widget.roomId)
  //         .collection('Chat')
  //         .add({
  //       'text': fileUrl,
  //       'type': 'audio',
  //       'createdAt': Timestamp.now(),
  //       'userId': user.uid,
  //       'userCode': AppConstants.userCode,
  //     }).whenComplete(() {
  //       setState(() {
  //         uploading = false;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        Dimensions.height10,
      ),
      child: uploading
          ? const Center(
              child: LinearProgressIndicator(),
            )
          : Row(
              children: [
                IconButton(
                  onPressed: _sendFile,
                  icon: const Icon(
                    Icons.image,
                    color: AppColors.mainColor,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enableSuggestions: true,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: AppColors.mainColor,
                  ),
                ),
                // BlocBuilder<RecordCubit, state.RecordState>(
                //   builder: (context, stat) {
                //     if (stat is state.RecordStopped ||
                //         stat is state.RecordInitial) {
                //       return IconButton(
                //         onPressed: () {
                //           context.read<RecordCubit>().startRecording();
                //         },
                //         icon: const Icon(Icons.mic),
                //       );
                //     } else {
                //       return IconButton(
                //         onPressed: () {
                //           context.read<RecordCubit>().stopRecording();

                //           ///We need to refresh [FilesState] after recording is stopped
                //           // context.read<FilesCubit>().getFiles();
                //         },
                //         icon: const Icon(Icons.record_voice_over),
                //       );
                //     }
                //   },
                // ),
              ],
            ),
    );
  }
}
