import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eaqad_app/ui/profile/waseet_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'buyyer_profile.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  String state="none";
  Map<String,dynamic> userData={};
  void getUser()async{
    setState(() {
      state="loading";
    });
    String uid=FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String,dynamic>> data=await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(data.exists==false){
      setState(() {
        state="empty";
      });
    }else{


      String type=data.get("type");
      print(type);


      if(type.isNotEmpty){
        userData=data.data()!;

        setState(() {
          state=type;
        });
      }else{
        setState(() {
          state="empty";
        });
      }
    }
    print(state);
    print(userData);
  }
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    margin: EdgeInsets.all(12),
                    color:Colors.white70,
                    height: 40,
                    width: double.infinity,
                    child: Center(
                      child: Text("الملف الشخصي"),
                    ),
                  )
                ],
              ),
            ),
             Expanded(
               flex: 1,
               child: BlurryModalProgressHUD(
                  inAsyncCall: state=="loading",
                  blurEffectIntensity: 8,
                  progressIndicator: const CircularProgressIndicator(),
                  dismissible: false,
                  opacity: 0.4,
                  color: Theme.of(context).primaryColor,
                  child:state=="empty"?Center(
                    child: Text("خطا في استرجاع المعلومات"),

                  ):state=="waseet"?WaseetProfile(data: userData!):BuyyerProfile(data: userData!,),
                           ),
             )
            
          ],
        ),
      ),
    );
  }
}
