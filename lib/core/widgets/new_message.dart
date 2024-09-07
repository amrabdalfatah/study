import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .collection('Chat')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userCode': AppConstants.userCode,
    });
  }

  String fileChat = '';
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
          fileChat = result.xFiles.first.path;
          uploadedFile = result.files.single.bytes;
        }
      } else {
        final XFile? pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
        fileChat = pickedFile!.path;
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
    if (fileChat.trim().isEmpty) {
      return;
    }

    const uuid = Uuid();
    final key = uuid.v4();

    await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .putData(
          uploadedFile!,
        );
    final fileUrl = await FirebaseStorage.instance
        .ref()
        .child('chats/${widget.roomId}/$key')
        .getDownloadURL();

    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .collection('Chat')
        .add({
      'text': fileUrl,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userCode': AppConstants.userCode,
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        Dimensions.height10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enableSuggestions: true,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
            ),
          ),
          IconButton(
            onPressed: _sendFile,
            icon: const Icon(
              Icons.file_copy,
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
