import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompareScreen extends StatefulWidget {
  final Map<String,dynamic> selectedRealEstate;
  final List<Map<String,dynamic>> items;
  const CompareScreen({super.key, required this.selectedRealEstate, required this.items});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  @override
  void initState() {
    print(widget.items.length);
    widget.items.removeWhere((element) => element["id"]==widget.selectedRealEstate["id"]);
    print(widget.items.length);
    widget.items.add(widget.selectedRealEstate);
    print(widget.items.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return buildScaffold5(context);
  }


  Scaffold buildScaffold3(BuildContext context) {
    return Scaffold(
        body:  Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
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
                          child: Text("نتائج المقارنة"),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(flex:1,child:  Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(36)
                              ),
                              width: double.infinity,
                              child: Center(child: Text("صورة العقار",style: TextStyle(fontSize: 13),)),

                            ),
                          ),
                          SizedBox(height: 15,),

                          // Align(alignment:Alignment.topRight,child
                          //     : Text("معلومات العقار" ,style: TextStyle(fontSize: 22,color: Colors.black),)),
                          // SizedBox(height: 15,),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.price_change),
                              title: Text("السعر",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['price'],style: TextStyle(fontSize: 20),),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.hotel),
                              title: Text("عدد الغرف",style: TextStyle(fontSize: 13),),
                              //trailing: Text(widget.data['rooms'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.home),
                              title: Text("عمر العقار",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['age'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.home),
                              title: Text("المساحة",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ),

                          Card(
                            child: ListTile(
                              leading: Icon(Icons.home),
                              title: Text("الحي",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          ),




                        ],
                      )),
                      Expanded(flex:1,child: SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.33,
                        height:MediaQuery.sizeOf(context).height ,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,shrinkWrap: true,itemCount: widget.items.length,itemBuilder:
                            (C,i)=>SizedBox(width:MediaQuery.sizeOf(context).width*0.33,
                            height:MediaQuery.sizeOf(context).height,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(36)
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Image.network(widget.items[i]['image'],
                                          height: 250,width: double.infinity,fit: BoxFit.fill,)),

                                  ),
                                  SizedBox(height: 15,),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.items[i]['price'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.items[i]['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.items[i]['age'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.items[i]['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance.collection("districts").doc(widget.items[i]['district']).get(),
                                    builder: (context,sn){
                                      if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                        return SizedBox.shrink();
                                      }
                                      if(sn.hasData){
                                        print(sn.data?.data()!['name']);
                                        return Card(
                                          child: ListTile(

                                            title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                          ),

                                        );

                                      }
                                      return SizedBox.shrink();

                                    },),
                                ],
                              ),
                            ))),
                      ),),
                      Expanded(flex:1,child: SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.33,
                        height:MediaQuery.sizeOf(context).height ,
                        child:  Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(36)
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Image.network(widget.selectedRealEstate['image'],
                                          height: 250,width: double.infinity,fit: BoxFit.fill,)),

                                  ),
                                  SizedBox(height: 15,),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.selectedRealEstate['price'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.selectedRealEstate['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.selectedRealEstate['age'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(widget.selectedRealEstate['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance.collection("districts").doc(widget.selectedRealEstate['district']).get(),
                                    builder: (context,sn){
                                      if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                        return SizedBox.shrink();
                                      }
                                      if(sn.hasData){
                                        print(sn.data?.data()!['name']);
                                        return Card(
                                          child: ListTile(

                                            title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                          ),

                                        );

                                      }
                                      return SizedBox.shrink();

                                    },),
                                ],
                              ),
                            ),
                      ),),
                    ],
                  ),
                ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                  onPressed: () {
                          Navigator.pop(context);
                          },
                            child: Text(
                              'تغيير العقارات',
                              style: TextStyle(color: Colors.white,fontSize: 22),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size.fromHeight(50),
                            ),
                          ),
                ),
              ),
              ],
            ),
          ),
        )
    );
  }


  Scaffold buildScaffold4(BuildContext context) {
    return Scaffold(
        body:  Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
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
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.all(12),
                        color:Colors.white70,
                        height: 40,
                        width: double.infinity,
                        child: Center(
                          child: Text("نتائج المقارنة"),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(flex:1,child:  Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(36)
                              ),
                              width: double.infinity,
                              child: Center(child: Text("صورة العقار",style: TextStyle(fontSize: 13),)),

                            ),
                          ),
                          SizedBox(height: 15,),


                              Divider(color: Colors.black26,),
                            ListTile(
                             // leading: Icon(Icons.price_change),
                              title: Text("السعر",style: TextStyle(fontSize: 15),),
                              // trailing: Text(widget.data['price'],style: TextStyle(fontSize: 20),),

                          ),
                          Divider(color: Colors.black26,),
                         ListTile(
                              //leading: Icon(Icons.hotel),
                              title: Text("عدد الغرف",style: TextStyle(fontSize: 15),),
                              //trailing: Text(widget.data['rooms'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          Divider(color: Colors.black26,),
                          ListTile(
                              //leading: Icon(Icons.home),
                              title: Text("عمر العقار",style: TextStyle(fontSize: 15),),
                              // trailing: Text(widget.data['age'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          Divider(color: Colors.black26,),
                           ListTile(
                            //  leading: Icon(Icons.home),
                              title: Text("المساحة",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          Divider(color: Colors.black26,),

                         ListTile(
                             // leading: Icon(Icons.home),
                              title: Text("الحي",style: TextStyle(fontSize: 13),),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                          Divider(color: Colors.black26,),





                        ],
                      )),
                      Expanded(flex:1,child: SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.33,
                        height:MediaQuery.sizeOf(context).height ,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,shrinkWrap: true,itemCount: widget.items.length,itemBuilder:
                            (C,i)=>SizedBox(width:MediaQuery.sizeOf(context).width*0.33,
                            height:MediaQuery.sizeOf(context).height,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(36)
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16.0),
                                        child: Image.network(widget.items[i]['image'],
                                          height: 250,width: double.infinity,fit: BoxFit.fill,)),

                                  ),
                                  SizedBox(height: 10,),
                                   Divider(color: Colors.black26,),
                                   ListTile(
                                      title: Text(widget.items[i]['price'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  Divider(color: Colors.black26,),
                                   ListTile(
                                      title: Text(widget.items[i]['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  Divider(color: Colors.black26,),
                                  ListTile(
                                      title: Text(widget.items[i]['age'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                    ),
                                  Divider(color: Colors.black26,),
                                   ListTile(
                                      title: Text(widget.items[i]['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                                    ),
                                  Divider(color: Colors.black26,),
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance.collection("districts").doc(widget.items[i]['district']).get(),
                                    builder: (context,sn){
                                      if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                        return SizedBox.shrink();
                                      }
                                      if(sn.hasData){
                                        print(sn.data?.data()!['name']);
                                        return  ListTile(

                                            title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),


                                        );

                                      }
                                      return SizedBox.shrink();

                                    },),
                                  Divider(color: Colors.black26,),
                                ],
                              ),
                            ))),
                      ),),
                      Expanded(flex:1,child: SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.33,
                        height:MediaQuery.sizeOf(context).height ,
                        child:  Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(36)
                                ),
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(widget.selectedRealEstate['image'],
                                      height: 250,width: double.infinity,fit: BoxFit.fill,)),

                              ),
                              SizedBox(height: 10,),
                              Divider(color: Colors.black26,),
                              ListTile(
                                  title: Text(widget.selectedRealEstate['price'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                ),
                              Divider(color: Colors.black26,),
                               ListTile(
                                  title: Text(widget.selectedRealEstate['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                ),
                              Divider(color: Colors.black26,),
                               ListTile(
                                  title: Text(widget.selectedRealEstate['age'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                ),
                              Divider(color: Colors.black26,),
                               ListTile(
                                  title: Text(widget.selectedRealEstate['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                                ),
                              Divider(color: Colors.black26,),
                              FutureBuilder(
                                future: FirebaseFirestore.instance.collection("districts").doc(widget.selectedRealEstate['district']).get(),
                                builder: (context,sn){
                                  if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                    return SizedBox.shrink();
                                  }
                                  if(sn.hasData){
                                    print(sn.data?.data()!['name']);
                                    return  ListTile(

                                        title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),


                                    );

                                  }
                                  return SizedBox.shrink();

                                },),
                              Divider(color: Colors.black26,),
                            ],
                          ),
                        ),
                      ),),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'تغيير العقارات',
                        style: TextStyle(color: Colors.white,fontSize: 22),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size.fromHeight(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }


  // build horzontal List
  Widget buildScaffold5(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.items.removeWhere((element) => element["id"]==widget.selectedRealEstate["id"]);
        return Future(() => true);
      },
      child: Scaffold(
          body:  Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
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
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.all(12),
                          color:Colors.white70,
                          height: 40,
                          width: double.infinity,
                          child: Center(
                            child: Text("نتائج المقارنة"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Expanded(flex:1,child:  Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(36)
                                ),
                                width: double.infinity,
                                child: Center(child: Text("صورة العقار",style: TextStyle(fontSize: 13),)),

                              ),
                            ),
                            SizedBox(height:21,),


                            Divider(color: Colors.black26,height: 5,),
                            ListTile(
                              // leading: Icon(Icons.price_change),
                              title: Text("السعر",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                              // trailing: Text(widget.data['price'],style: TextStyle(fontSize: 20),),

                            ),
                            Divider(color: Colors.black26,height: 5,),
                            ListTile(
                              //leading: Icon(Icons.hotel),
                              title: Text("عدد الغرف",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                              //trailing: Text(widget.data['rooms'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                            Divider(color: Colors.black26,height: 5,),
                            ListTile(
                              //leading: Icon(Icons.home),
                              title: Text("عمر العقار",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                              // trailing: Text(widget.data['age'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                            Divider(color: Colors.black26,height: 5,),
                            ListTile(
                              //  leading: Icon(Icons.home),
                              title: Text("المساحة",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                            Divider(color: Colors.black26,height: 5,),

                            ListTile(
                              // leading: Icon(Icons.home),
                              title: Text("الحي",style: TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                              // trailing: Text(widget.data['space'].toString(),style: TextStyle(fontSize: 20),),
                            ),
                            Divider(color: Colors.black26,height: 5,),





                          ],
                        )),
                        Expanded(flex:2,child: SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.33,
                         // height:MediaQuery.sizeOf(context).height ,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,shrinkWrap: true,itemCount: widget.items.length,itemBuilder:
                              (C,i)=>SizedBox(width:MediaQuery.sizeOf(context).width*0.33,
                             // height:MediaQuery.sizeOf(context).height,
                              child: Card(

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      widget.selectedRealEstate["id"]==widget.items[i]["id"]?Icon(Icons.star,size: 15,):
                                      SizedBox(height: 15,),


                                      Container(
                                        height: 100,
                                        decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(36)
                                        ),
                                        width: double.infinity,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16.0),
                                            child: Image.network(widget.items[i]['image'],
                                              height: 250,width: double.infinity,fit: BoxFit.fill,)),

                                      ),
                                      SizedBox(height: 10,),
                                      Divider(color: Colors.black26,height: 5,),
                                      ListTile(
                                        title: Text(widget.items[i]['price'],textAlign:TextAlign.center,overflow:
                                        TextOverflow.visible,style: TextStyle(fontSize: 13)),
                                      ),
                                      Divider(color: Colors.black26,height: 5,),
                                      ListTile(
                                        title: Text(widget.items[i]['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                      ),
                                      Divider(color: Colors.black26,height: 5,),
                                      ListTile(
                                        title: Text(widget.items[i]['age'].toString(),
                                          textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                                      ),
                                      Divider(color: Colors.black26,height: 5,),
                                      ListTile(
                                        title: Text(widget.items[i]['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                                      ),
                                      Divider(color: Colors.black26,height: 5,),
                                      FutureBuilder(
                                        future: FirebaseFirestore.instance.collection("districts").doc(widget.items[i]['district']).get(),
                                        builder: (context,sn){
                                          if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                                            return SizedBox.shrink();
                                          }
                                          if(sn.hasData){
                                            print(sn.data?.data()!['name']);
                                            return  ListTile(

                                              title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow:
                                              TextOverflow.visible,style: TextStyle(fontSize: 13),),


                                            );

                                          }
                                          return SizedBox.shrink();

                                        },),
                                      Divider(color: Colors.black26,height: 5,),
                                    ],
                                  ),
                                ),
                              ))),
                        ),),
                        // Expanded(flex:1,child: SizedBox(
                        //   width: MediaQuery.sizeOf(context).width*0.33,
                        //   height:MediaQuery.sizeOf(context).height ,
                        //   child:  Padding(
                        //     padding: const EdgeInsets.all(6.0),
                        //     child: Column(
                        //       children: [
                        //         SizedBox(height: 15,),
                        //         Container(
                        //           height: 100,
                        //           decoration: BoxDecoration(
                        //
                        //               borderRadius: BorderRadius.circular(36)
                        //           ),
                        //           width: double.infinity,
                        //           child: ClipRRect(
                        //               borderRadius: BorderRadius.circular(16.0),
                        //               child: Image.network(widget.selectedRealEstate['image'],
                        //                 height: 250,width: double.infinity,fit: BoxFit.fill,)),
                        //
                        //         ),
                        //         SizedBox(height: 10,),
                        //         Divider(color: Colors.black26,),
                        //         ListTile(
                        //           title: Text(widget.selectedRealEstate['price'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                        //         ),
                        //         Divider(color: Colors.black26,),
                        //         ListTile(
                        //           title: Text(widget.selectedRealEstate['rooms'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                        //         ),
                        //         Divider(color: Colors.black26,),
                        //         ListTile(
                        //           title: Text(widget.selectedRealEstate['age'].toString(),textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                        //         ),
                        //         Divider(color: Colors.black26,),
                        //         ListTile(
                        //           title: Text(widget.selectedRealEstate['space'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13,),),
                        //         ),
                        //         Divider(color: Colors.black26,),
                        //         FutureBuilder(
                        //           future: FirebaseFirestore.instance.collection("districts").doc(widget.selectedRealEstate['district']).get(),
                        //           builder: (context,sn){
                        //             if(sn.hasError || sn.connectionState==ConnectionState.waiting){
                        //               return SizedBox.shrink();
                        //             }
                        //             if(sn.hasData){
                        //               print(sn.data?.data()!['name']);
                        //               return  ListTile(
                        //
                        //                 title: Text(sn.data?.data()!['name'],textAlign:TextAlign.center,overflow: TextOverflow.visible,style: TextStyle(fontSize: 13),),
                        //
                        //
                        //               );
                        //
                        //             }
                        //             return SizedBox.shrink();
                        //
                        //           },),
                        //         Divider(color: Colors.black26,),
                        //       ],
                        //     ),
                        //   ),
                        // ),),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.items.removeWhere((element) => element["id"]==widget.selectedRealEstate["id"]);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'تغيير العقارات',
                          style: TextStyle(color: Colors.white,fontSize: 22),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: Size.fromHeight(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

}
