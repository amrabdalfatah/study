import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/constants.dart';
import 'package:study_academy/core/utils/dimensions.dart';

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
              // TODO: Make all text form field like this
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
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
