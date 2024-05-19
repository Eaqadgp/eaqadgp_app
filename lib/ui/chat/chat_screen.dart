import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String? conversationId;

  const ChatScreen({super.key, required this.userId, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = types.User(
    id: FirebaseAuth.instance.currentUser!.uid,
  );


  @override
  void initState() {
    super.initState();
    id = widget.conversationId;
    if (id == null) {
      update();
    }


    //_loadMessages();

  }

  void update() async {
    String? tempId;
    QuerySnapshot<Map<String, dynamic>> conversation = await FirebaseFirestore
        .instance.collection("conversation").get();
    for (var element in conversation.docs) {
      if ((element.data()["person1"] == widget.userId &&
          element.data()["person2"] ==
              FirebaseAuth.instance.currentUser!.uid) ||
          (element.data()["person1"] ==
              FirebaseAuth.instance.currentUser!.uid &&
              element.data()["person2"] == widget.userId)) {
      //  setState(() {
          tempId = element.data()["id"];
       // });
      //  break;
      }
    }
    if (tempId != null) {
      setState(() {
        id=tempId;
      });
    }
  }

  String? id;

  void _addMessage(types.Message message) {
    if (id == null) {
      String tempId = FirebaseFirestore.instance
          .collection("conversation")
          .doc()
          .id;
      FirebaseFirestore.instance.collection("conversation").doc(id).set({
        "id": tempId,
        "person1": FirebaseAuth.instance.currentUser!.uid,
        "person2": widget.userId,
        "lastMessage": message is types.FileMessage ? "File" : message is types
            .ImageMessage ? "Photo" : (message as types.TextMessage).text
      });
      var m = message.copyWith(
          roomId: tempId
      );
      FirebaseFirestore.instance.collection("chats").doc(m.id).set(m.toJson());
      setState(() {
        _messages.insert(0, message);
        id=tempId;
      });

    } else {
      FirebaseFirestore.instance.collection("conversation").doc(id).update({
        "lastMessage": message is types.FileMessage ? "File" : message is types
            .ImageMessage ? "Photo" : (message as types.TextMessage).text
      });
      FirebaseFirestore.instance.collection("chats").doc(message.id).set(
          message.toJson());
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) =>
          SafeArea(
            child: SizedBox(
              height: 144,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleImageSelection();
                    },
                    child: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Photo'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleFileSelection();
                    },
                    child: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('File'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        roomId: id,
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,

      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final storageRef = FirebaseStorage.instance.ref("chats");
      File file = File(result.path);

      try {
        TaskSnapshot uploadTask = await storageRef.putFile(file);
        String url = await uploadTask.ref.getDownloadURL();
        final message = types.ImageMessage(
          author: _user,
          roomId: id,
          createdAt: DateTime
              .now()
              .millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: url,
          width: image.width.toDouble(),
        );

        _addMessage(message);
      } on FirebaseException catch (e) {
        // ...
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          _messages.indexWhere((element) => element!.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
          _messages.indexWhere((element) => element!.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message,
      types.PreviewData previewData,) {
    final index = _messages.indexWhere((element) => element!.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      roomId: id,
      createdAt: DateTime
          .now()
          .millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    print(textMessage.toJson());

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("chats").where("roomId", isEqualTo: id).get();
    // data.docs.removeWhere((element) => element.data()["author"]["id"]!=uid||  element.data()["author"]["id"]!=widget.userId);

  }

  Widget nameBuilder(types.User user) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(user.id).get(),
      builder: (context, sn) {
        if (sn.hasError || sn.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        if (sn.hasData) {
          return Text("${sn.data?.data()!['firstName']} ${sn.data
              ?.data()!['lastName']} ");
        }
        return SizedBox.shrink();
      },);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Icon(Icons.perm_identity,size: 40,color: Colors.white,),
          title: FutureBuilder(
            future: FirebaseFirestore.instance.collection("users").doc(widget.userId).get(),
            builder: (context, sn) {
              if (sn.hasError || sn.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              if (sn.hasData) {
                return Text("${sn.data?.data()!['firstName']} ${sn.data
                    ?.data()!['lastName']} ",style: TextStyle(fontSize: 22,color: Colors.white),);
              }
              return SizedBox.shrink();
            },),
        ),
        body:StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chats").where(
                "roomId", isEqualTo: id).snapshots(),
            builder: (context, data) {
              // if (data.connectionState == ConnectionState.waiting)
              //   return Center(child: CircularProgressIndicator(),);
              if (data.hasError) return Center(child: Text(
                "لاتوجد رسائل بعد", style: TextStyle(fontSize: 23),),);
              if (data.hasData) {
                _messages.clear();
                final messages = data.data!.docs
                    .map((e) {
                  return types.Message.fromJson(e.data());
                }).toList();
                //sort
                messages.sort((v1, v2) =>
                v1.createdAt!.compareTo(v2.createdAt!) == 1 ? -1 : 1);
                _messages.addAll(messages);
                _messages.removeWhere((element) => element.roomId!=id);
                return Chat(
                  messages: id==null?[]:_messages,
                  nameBuilder: nameBuilder,

                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,

                  user: _user,
                  theme: const DefaultChatTheme(
                    seenIcon: Text(
                      'read',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                );
              }
              return Center(child: Text("لاتوجد رسائل بعد",style: TextStyle(fontSize: 23)));
            }
        ),
      );


}
