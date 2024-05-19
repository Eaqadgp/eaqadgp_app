import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatefulWidget {
  final String id;
  final String lastMessage;
  final Function click;
  const ConversationItem({super.key, required this.id, required this.click, required this.lastMessage});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(widget.id).get(),
      builder: (context,sn){
        if(sn.hasError || sn.connectionState==ConnectionState.waiting){
          return SizedBox.shrink();
        }
        if(sn.hasData){
          return InkWell(
            onTap: (){
              widget.click();
            },
            child: Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("${sn.data?.data()!['firstName']} ${sn.data?.data()!['lastName']} "),
                subtitle: Text(widget.lastMessage),
                trailing: InkWell(onTap:(){

                },child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,)),
              ),
            ),
          );

        }
        return SizedBox.shrink();

      },);
  }
}
