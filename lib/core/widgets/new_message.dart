import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
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
  bool isShowSendButton = false;
  FlutterSoundRecorder? soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void selectImage() async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image?.path != null) {
        sendFileMessage(File(image!.path), 'image');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  void selectVideo() async {
    try {
      XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (video?.path != null) {
        sendFileMessage(File(video!.path), 'video');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  void selectPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        sendFileMessage(File(file.path!), 'pdf', fileName: file.name);
      }
      // XFile? file = await _picker.pickMedia();
      // if (file?.path != null) {
      //   sendFileMessage(File(file!.path), 'pdf');
      // }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  sendMessage() async {
    if (isShowSendButton) {
      final enteredMessage = _messageController.text;
      if (enteredMessage.trim().isEmpty) {
        return;
      }
      FocusScope.of(context).unfocus();
      _messageController.clear();
      final uuid = const Uuid().v4();
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
      setState(() {
        isShowSendButton = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await soundRecorder!.stopRecorder();
        sendFileMessage(File(path), 'audio');
      } else {
        await soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, String messageEnum,
      {String fileName = ''}) async {
    setState(() {
      uploading = true;
    });
    final key = const Uuid().v4();
    await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .putFile(file);
    final fileUrl = await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .getDownloadURL();
    final uid = const Uuid().v4();

    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .collection('Chat')
        .doc(uid)
        .set({
      'text': fileUrl,
      'type': messageEnum,
      'id': uid,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userCode': AppConstants.userCode,
      'fileName': fileName,
    }).whenComplete(() {
      setState(() {
        uploading = false;
      });
    });
  }

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
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      } else {
                        setState(() {
                          isShowSendButton = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Which Type:',
                                  content: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          selectVideo();
                                        },
                                        child: SizedBox(
                                          height: Dimensions.height50,
                                          child: Center(
                                            child: BigText(
                                              text: 'Video',
                                              color: Colors.black,
                                              size: Dimensions.font16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          selectPdf();
                                        },
                                        child: SizedBox(
                                          height: Dimensions.height50,
                                          child: Center(
                                            child: BigText(
                                              text: 'PDF',
                                              color: Colors.black,
                                              size: Dimensions.font16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    right: 2,
                    left: 2,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 25,
                    child: GestureDetector(
                      onTap: sendMessage,
                      child: Icon(
                        isShowSendButton
                            ? Icons.send
                            : isRecording
                                ? Icons.stop
                                : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      // : Row(
      //     children: [
      //       IconButton(
      //         onPressed: _sendFile,
      //         icon: const Icon(
      //           Icons.image,
      //           color: AppColors.mainColor,
      //         ),
      //       ),
      //       Expanded(
      //         child: TextField(
      //           controller: _messageController,
      //           enableSuggestions: true,
      //           autocorrect: false,
      //           textCapitalization: TextCapitalization.none,
      //           decoration: const InputDecoration(
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //       ),
      //       IconButton(
      //         onPressed: _sendMessage,
      //         icon: const Icon(
      //           Icons.send,
      //           color: AppColors.mainColor,
      //         ),
      //       ),
      //     ],
      //   ),
    );
  }
}
