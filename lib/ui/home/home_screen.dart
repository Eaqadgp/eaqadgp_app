import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:eaqad_app/model/filter_model.dart';
import 'package:eaqad_app/ui/home/filter_sheet.dart';
import 'package:eaqad_app/ui/home/item.dart';
import 'package:eaqad_app/ui/profile/buyyer_profile.dart';
import 'package:eaqad_app/ui/profile/main_profile.dart';
import 'package:eaqad_app/ui/profile/waseet_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
//import 'package:intl/intl.dart';

import '../../model/utill_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String state="none";
  var loading=false;
  var isDataFound=false;

  var list=[];
  var list2=[];
  var searchList=[];
  var filterList=[];
  void getAll()async{
    list.clear();
    setState(() {
      loading=true;
      state="loading";
    });
    QuerySnapshot<Map<String,dynamic>> data=await FirebaseFirestore.instance.collection("realEstate").get();
    setState(() {
      loading=false;

    });
    if(data.docChanges.isEmpty){
      setState(() {
        isDataFound=false;
        state="empty";
      });
    }else{
     

      data.docs.forEach((element) {

        list2.add(element.data());

      });


      setState(() {
        isDataFound=true;
        state="data";

        list=list2;
      });


    }
  }
  @override
  void initState() {

  //  addData();
   getAll();
    super.initState();
  }

  void addData() async{
    newData.forEach((element) async {
       String id=FirebaseFirestore.instance.collection("realEstate").doc().id;
       element["id"]=id;
       print(id);
      await FirebaseFirestore.instance.collection("realEstate").doc(id).set(element);

    });
  }

  void search(String v) {


    searchList.clear();


    if(v.isEmpty){
      setState(() {
        state="data";
      });
    }else{
      list2.forEach((element) {
        if((element["number"] as String).contains(v) ||(element["name"] as String).contains(v)){
          searchList.add(element);
        }
      });
      if(searchList.isEmpty){
        setState(() {
          isDataFound=false;
          state="empty";
        });
      }else{
        setState(() {
          isDataFound=true;
          state="search";
        });




      }
    }
  }
  Map<String,dynamic> userData={};
  void getUser()async{
    String pervoisuState=state;
    setState(() {
      state="loading";
    });
    String uid=FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String,dynamic>> data=await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(data.exists==false){
      setState(() {
        state=pervoisuState;
      });
      final snackbar=SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: "خطا",
          message: "خطا في استرجاع معلومات الملف الشخصي",
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);
    }else{


      String type=data.get("type");
      print(type);


      if(type.isNotEmpty){
        setState(() {
          state=pervoisuState;
        });
        userData=data.data()!;
        if(type=="waseet"){
          Navigator.push(context, MaterialPageRoute(builder: (c)=>WaseetProfile(data: userData)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (c)=>BuyyerProfile(data: userData)));
        }
      }else{
        setState(() {
          state="none";
        });
        final snackbar=SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "خطا",
            message: "خطا في استرجاع معلومات الملف الشخصي",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);
      }
    }
    print(state);
    print(userData);
  }
  void showConfirmEmailDialog() async{
    if (await confirm(
      context,
      title: const Text('تنبيه',textAlign: TextAlign.right,),
      content: const Text('لقد قمت بتغيير البريد الاليكتروني ولكي يتم تطبيق التغييرات الجديدة واستخدام البريد الاليكتروني الجديد , تم ارسال بريد تحقق على بريدك الاليكتروني , قم بتفعيل بريدك الجديد لكي تتمكن من استخدامه, عدا ذلك سوف يبقى البريد القديم مستخدما',textAlign: TextAlign.right,style: TextStyle(fontSize: 22,color: Colors.black),),
      textOK: const Text('حسنا',textAlign: TextAlign.right,),
      textCancel: const Text('اغلاق',textAlign: TextAlign.right,),
    )) {
      return print('pressedOK');
    }
    return print('pressedCancel');
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(

          child: BlurryModalProgressHUD(
            inAsyncCall: state=="loading",
            blurEffectIntensity: 8,
            progressIndicator: const CircularProgressIndicator(),
              dismissible: false,
              opacity: 0.4,
              color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                             // Navigator.push(context, MaterialPageRoute(builder: (c)=>const MainProfile()));
                              getUser();
                              //showConfirmEmailDialog();
                            },
                            child:  Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Image.asset(
                                    width: 40,
                                    height: 40,
                                    "assets/images/account.png",
                                ),
                            ),

                          )),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 6,
                        child: TextField(
                          textAlign: TextAlign.end,

                          onChanged: (v){
                            search(v);
                          },

                         textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'بحث',
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 20,right: 20),
                              border: OutlineInputBorder(),
                              fillColor: Color.fromARGB(255, 241, 241, 241),


                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                showFlexibleBottomSheet(
                                  minHeight: 0,
                                  isExpand:true,
                                  initHeight: 0.5,
                                  maxHeight: 1,
                                  context: context,
                                  builder: (c, scrollController, i) {
                                    return FilterSheet(onFilter: filter,);
                                  },
                                  anchors: [0, 0.5, 1],
                                  isSafeArea: true,
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.blueGrey)
                                ),
                                child: Image.asset(
                                  "assets/images/filter.png"
                                ),
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: state=="empty"?
                      const Center(
                        child: Text("لاتوجد بيانات"),
                      ):state=="data"?ListView.builder(
                          itemCount: list2.length,
                          itemBuilder: (c, i) => Item(
                                data: list2[i] as Map<String,dynamic>,
                              )):state=="search"?ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (c, i) => Item(
                            data: searchList[i] as Map<String,dynamic>,
                          )):ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (c, i) => Item(
                            data: filterList[i] as  Map<String,dynamic>,
                          ))
                  ),
                ],
              ),
            ),
          ),
        ),

    );
  }
  void filter(FilterModel model){

    filterList.clear();
    filterList.addAll(list2);
    print("filter before = ${filterList.length}");
    // filter price
    filterList.removeWhere((element) {
      double price=double.parse(element['price']);
      bool result=price>model.start && price<model.end;
      print(price );
      print(result );
      return !result;
    });
    print("filter after price = ${filterList.length}");
    // filter disricts
    if(model.districts.isNotEmpty){
      filterList.removeWhere((element) {
        bool isDistrict=model.districts.contains(element["district"]);
        return !isDistrict;
      });
    }
    print("filter after disricts = ${filterList.length}");

    if(model.rooms.isNotEmpty){
      filterList.removeWhere((element) {
        bool rooms=!model.rooms.contains(element["rooms"] as int);
        return rooms;
      });
    }
    print(filterList.length);
    if(filterList.isNotEmpty){
      setState(() {
        state="filter";
      });
    }else{
      state="empty";
    }


  }
}


