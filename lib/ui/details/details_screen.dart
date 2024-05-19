import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eaqad_app/ui/chat/chat_screen.dart';
import 'package:eaqad_app/ui/compare/choose_real_estate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final Map<String,dynamic> data;
  const Details({super.key, required this.data});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    print(widget.data['waseet']);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(

          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   InkWell(
                     onTap: (){
                       Navigator.pop(context);
                     },
                     child: Align(alignment:Alignment.topRight,child
                        : Icon(Icons.arrow_back_ios)),
                   ),
                  SizedBox(height: 15,),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36)
                    ),
                    width: double.infinity,
                    child: ClipRRect(borderRadius: BorderRadius.circular(23),child:
                    Image.network(widget.data['image'],height: 250,width: double.infinity,fit: BoxFit.fill,)),

                  ),
                  SizedBox(height: 15,),

                Align(alignment:Alignment.topRight,child
                        : Text("معلومات العقار" ,style: TextStyle(fontSize: 22,color: Colors.black),)),
                  SizedBox(height: 15,),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.price_change),
                      title: Text("السعر"),
                      trailing: Text(widget.data['price'],style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.hotel),
                      title: Text("عدد الغرف"),
                      trailing: Text(widget.data['rooms'].toString(),style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("عمر العقار"),
                      trailing: Text(widget.data['age'].toString(),style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("المساحة"),
                      trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                    ),
                  ),


                  widget.data['district']==null?SizedBox.shrink(): FutureBuilder(
                    future: FirebaseFirestore.instance.collection("districts").doc(widget.data['district']).get(),
                    builder: (context,sn){
                      if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                        return SizedBox.shrink();
                      }
                      if(sn.hasData){
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.home),
                            title: Text("الحي"),
                            trailing: Text(sn.data?.data()!['name'],style: TextStyle(fontSize: 20),),
                          ),
                        );

                      }
                      return SizedBox.shrink();

                    },),
                  (widget.data['waseet'] as String?)==null?const SizedBox.shrink():FutureBuilder(
                    future: FirebaseFirestore.instance.collection("users").doc(widget.data['waseet']).get(),
                    builder: (context,sn){
                      if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                        return SizedBox.shrink();
                      }
                      if(sn.hasData){
                        String firstName=sn.data?.data()==null?null:sn.data?.data()!['firstName'];
                        String lastName=sn.data?.data()==null?null:sn.data?.data()!['lastName'];
                        print(firstName);
                        print(lastName);
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text((firstName==null && lastName==null)?"خطا في استرجاع الاسم":"${firstName} ${lastName}" ),
                            subtitle: Text("وسيط عقاري"),
                            trailing: InkWell(onTap:(){
                              String uid=FirebaseAuth.instance.currentUser!.uid;
                              if(uid!=sn.data?.data()!['id']){
                                Navigator.push(context, MaterialPageRoute(builder: (c)=>ChatScreen(userId:sn.data?.data()!['id'] )));

                              }
                            },child: Icon(Icons.email,color: Colors.blue,)),
                          ),
                        );

                      }
                      return SizedBox.shrink();

                    },),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>ChooseRealEstate(selectedRealEstate: widget.data,)));
                    },
                    child: Text(
                      'مقارنة',
                      style: TextStyle(color: Colors.white,fontSize: 22),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
