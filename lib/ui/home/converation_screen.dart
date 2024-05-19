import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eaqad_app/ui/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'conversation_item.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  bool loading = false;
  var _conversationList = [];
  String id = FirebaseAuth.instance.currentUser!.uid;
  String state = "none";

  void getAllConversation() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("conversation").get();

    setState(() {
      loading = false;
    });

    if (data.size == 0) {
      setState(() {
        state = "empty";
      });
    } else {
      data.docChanges.forEach((element) {
        if ((element.doc.data()!["person1"] as String) == id ||
            (element.doc.data()!["person2"]) == id) {
          _conversationList.add(element.doc.data());
        }
      });
      if(_conversationList.isEmpty){
        setState(() {
          state="empty";
        });
      }
    }
    print(state);
  }
  @override
  void initState() {
    getAllConversation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
        inAsyncCall: loading,
        blurEffectIntensity: 8,
        progressIndicator: const CircularProgressIndicator(),
        dismissible: false,
        opacity: 0.4,
        color: Theme.of(context).primaryColor,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      color: Colors.white70,
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Text("المحادثات"),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: buildExpanded2(context))
            ],
          ),
        ));
  }
  Expanded buildExpanded2(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("conversation").snapshots(),
        builder:(context,data){
          if(data.connectionState==ConnectionState.waiting)return Center(child: CircularProgressIndicator(),);
          if(data.hasError)return Center(child: Text("لاتوجد محادثات بعد",style: TextStyle(fontSize: 23),),);
          if(data.hasData){
            _conversationList.clear();
            data.data?.docs.forEach((element) {
              if ((element.data()["person1"] as String) == id ||
                  (element.data()["person2"]) == id) {
                _conversationList.add(element.data());
              }
            });
            if(_conversationList.isEmpty){
              return Center(child: Text("لاتوجد محادثات بعد",style: TextStyle(fontSize: 23),),);
            }
            if(_conversationList.isNotEmpty){
              return ListView.builder(
                  itemCount: _conversationList.length,
                  itemBuilder: (c, i) => ConversationItem(
                    id: _conversationList[i]["person1"] == id
                        ? _conversationList[i]["person2"]
                        : _conversationList[i]["person1"],
                    lastMessage: _conversationList[i]
                    ["lastMessage"],
                    click: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => ChatScreen(
                                  userId: _conversationList[i]
                                  ["person1"] ==
                                      id
                                      ? _conversationList[i]
                                  ["person2"]
                                      : _conversationList[i]
                                  ["person1"],
                                  conversationId:
                                  _conversationList[i]
                                  ["id"])));
                    },
                  ));
            }
          }

          return Text("empty");
        }),
    );
  }
  Expanded buildExpanded(BuildContext context) {
    return Expanded(
                    child: state == "empty"
                        ? Center(
                            child: Text(
                              "لاتوجد محادثات بعد",
                              style: TextStyle(
                                  fontSize: 22, color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _conversationList.length,
                            itemBuilder: (c, i) => ConversationItem(
                                  id: _conversationList[i]["person1"] == id
                                      ? _conversationList[i]["person2"]
                                      : _conversationList[i]["person1"],
                                  lastMessage: _conversationList[i]
                                      ["lastMessage"],
                                  click: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => ChatScreen(
                                                userId: _conversationList[i]
                                                            ["person1"] ==
                                                        id
                                                    ? _conversationList[i]
                                                        ["person2"]
                                                    : _conversationList[i]
                                                        ["person1"],
                                                conversationId:
                                                    _conversationList[i]
                                                        ["id"])));
                                  },
                                )));
  }
}
