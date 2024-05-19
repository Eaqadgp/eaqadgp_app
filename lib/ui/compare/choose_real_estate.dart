import 'dart:collection';
import 'dart:math';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:eaqad_app/ui/compare/choose_item.dart';
import 'package:eaqad_app/ui/compare/compare_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../home/item.dart';

class ChooseRealEstate extends StatefulWidget {
  final Map<String,dynamic> selectedRealEstate;
  const ChooseRealEstate({super.key, required this.selectedRealEstate});

  @override
  State<ChooseRealEstate> createState() => _ChooseRealEstateState();
}

class _ChooseRealEstateState extends State<ChooseRealEstate> {
  List<Map<String, dynamic>> list = [];
  var MAX_SELECTOR = 3;
  var list2 = [];
  var loading = false;
  var isDataFound = false;
  String state = "none";

  void getAll() async {
    list.clear();
    setState(() {
      loading = true;
      state = "loading";
    });
    QuerySnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection("realEstate").get();
    setState(() {
      loading = false;
    });
    if (data.docChanges.isEmpty) {
      setState(() {
        isDataFound = false;
        state = "empty";
      });
    } else {
      data.docs.forEach((element) {
        if(widget.selectedRealEstate['id'] !=element["id"]){
          list.add(element.data());
        }

      });

      setState(() {
        isDataFound = true;
        state = "data";
      });
    }
  }

  @override
  void initState() {
    //addData();
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اختر العقار للمقارنة"),
      ),
      body: SafeArea(
        child: BlurryModalProgressHUD(
          inAsyncCall: state == "loading",
          blurEffectIntensity: 8,
          progressIndicator: const CircularProgressIndicator(),
          dismissible: false,
          opacity: 0.4,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "اختر ما لايزيد عن 3 عقارات ",
                  style: TextStyle(fontSize: 23),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 16,
                  child: state == "empty"
                      ? const Center(
                          child: Text("لاتوجد بيانات"),
                        )
                      : state == "data"
                          ? buildListView()
                          : const SizedBox.shrink(),
                ),
                Spacer(
                  flex: 1,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selected.isEmpty) {
                      showWaringMessage();
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>CompareScreen(
                        selectedRealEstate: widget.selectedRealEstate,
                        items: selected,
                      )));
                    }
                  },
                  child: Text(
                    'استمرار',
                    style: TextStyle(color: Colors.white, fontSize: 22),
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
    );
  }

  List<Map<String, dynamic>> selected = [];

  ListView buildListView() {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (c, i) => ChooseItem(
              isSelected: selected.contains(list[i]),
              onTap: () {
                setState(() {
                  if (selected.contains(list[i])) {
                    selected.remove(list[i]);
                  } else {
                    if (selected.length == MAX_SELECTOR) {
                      showWaringMessage();
                    } else {
                      selected.add(list[i]);
                    }
                  }
                });
              },
              data: list[i],
            ));
  }

  void showWaringMessage()async {
    if (await confirm(
    context,
    title: const Text('تنبيه'),
    content: const Text('لايمكنك تجاوز الحد الاقصى 3 عقارات',style: TextStyle(fontSize: 22,color: Colors.black),),
    textOK: const Text('حسنا'),
    textCancel: const Text('اغلاق'),
    )) {
    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (v)=>const Login()), (route) => false);
    }else{

    }

  }
}
