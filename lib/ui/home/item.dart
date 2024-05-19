import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../details/details_screen.dart';

class Item extends StatefulWidget {
  final Map<String,dynamic>  data;
  const Item({super.key, required this.data});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (v)=>Details(data: widget.data,)));
      },
      child: Card(
       elevation: 4,
          shape:
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
        child: Container(

          decoration: BoxDecoration(

            //borderRadius: BorderRadius.circular(20),

          ),
          child: Column(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(23),child: Image.network(widget.data['image'],height: 200,width: double.infinity,fit: BoxFit.fill,)),
              SizedBox(height:
                10,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                     Expanded(
                       flex: 4,
                       child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text("${widget.data['name']}-${widget.data['city']}",style: TextStyle(fontSize: 14,color: Colors.black),),
                               SizedBox(height: 5,),
                                Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                        Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("الحي",style: TextStyle(fontSize: 13)),
                                            FutureBuilder(
                                                future: FirebaseFirestore.instance.collection("districts").doc(widget.data['district']).get(),
                                                 builder: (context,sn){
                                                  if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                                    return SizedBox.shrink();
                                                  }
                                                  if(sn.hasData){
                                                    return Text(sn.data?.data()!['name'],style: TextStyle(fontSize: 13),textAlign:TextAlign.center,overflow:
                                                    TextOverflow.visible);
                                                  }
                                                  return SizedBox.shrink();

                                                 },)
                                          ],
                                                                         ),


                                        SizedBox(width: 5),
                                       Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("رقم القطعة",style: TextStyle(fontSize: 13)),
                                            Text(widget.data['number'],textAlign:TextAlign.center,overflow:
                                            TextOverflow.visible)
                                          ],
                                                                          ),

                                      SizedBox(width: 5,),
                                       Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("المساحة",style: TextStyle(fontSize: 13)),
                                            Text(widget.data['space'],style: TextStyle(fontSize: 13),textAlign:TextAlign.center,overflow:
                                            TextOverflow.visible)
                                          ],
                                                                         ),

                                    ],
                                  ),




                            ],
                          ),
                     ),


                    SizedBox(width: 5,),

                    Container(
                      width: 2,
                      height: 69,
                      color: Colors.grey
                    ),
                    SizedBox(width: 5,),
                   Expanded(
                     child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("السعر",style: TextStyle(fontSize: 13,color: Colors.black),),
                            Text(widget.data["price"],style: TextStyle(fontSize: 13,color: Colors.grey),textAlign:TextAlign.center,overflow:
                            TextOverflow.visible),
                          ],
                        ),
                   ),

                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8),child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40,
                    width: 120,
                    alignment: Alignment.center,
                    child: Text("انقر للمزيد",style: TextStyle(fontSize: 17),),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),

                    ),
                  )

                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
