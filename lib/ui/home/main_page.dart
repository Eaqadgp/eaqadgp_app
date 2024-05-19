import 'package:app_settings/app_settings.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:eaqad_app/ui/home/converation_screen.dart';
import 'package:eaqad_app/ui/home/home_screen.dart';
import 'package:eaqad_app/ui/home/unity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var screens=[HomeScreen(),ConversationListScreen(),UnityScreen()];
  int index=0;
  var platform = MethodChannel('your_channel_name');
  Future<void> showUnityInAnotherScreen() async {
    try {
      await platform.invokeMethod('nativeMethod');
    } catch (e) {
      print('Error calling native method: $e');
    }
  }
  void showDialog({required String title,String? ok="حسنا",required String message,required Function() okPressed})async{
    if (await confirm(
      context,
      title:  Text(title,textAlign: TextAlign.right,),
      content:  Text(message,textAlign: TextAlign.right,style: TextStyle(fontSize: 22,color: Colors.black),),
      textOK: Text(ok!,textAlign: TextAlign.right,),
      textCancel: const Text('اغلاق',textAlign: TextAlign.right,),
    )) {
      okPressed();
      return print('pressedOK');
    }
    return print('pressed');
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  screens[index],
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
             await showUnity();
            //showUnityInAnotherScreen();

            },
          child: const Icon(Icons.document_scanner),
        ),
          floatingActionButtonLocation: FloatingActionButtonLocation
        .centerDocked,
        bottomNavigationBar: BottomAppBar(

          shape: const CircularNotchedRectangle(),

          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 60,

          notchMargin: 5,
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon:  Icon(
                    Icons.email_outlined,
                    size: 55,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {

                      setState(() {
                        index=1;

                      });


                  },
                ),
                InkWell(onTap:(){

                   setState(() {
                     index=0;
                   });



                },child
                    : Image.asset("assets/images/logo.png",width: 55,height: 55,))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showUnity() async {
      var status = await Permission.camera.status;
    if (status.isDenied) {
      showDialog(title: "تحذير", message: "لكى تتمكن من استخدام ميزة مسح المخطط يرجى تفعيل صلاحية الكامير",
          okPressed: ()async{  await requestPermmission();},ok: "تفعيل صلاحية الكاميرا" );

    }else if(status.isGranted){
      showUnityInSameScreen();
    }else if(status.isLimited){

    }else if(status.isPermanentlyDenied){
      showDialog(title: "تحذير", message: "لقد قمت برفض صلاحية الكاميرا بشكل نهائي ولكي تقوم بتفعيل صلاحية الكاميرا بشكل يدوي من اعدادات التطبيق",
          okPressed: (){
            AppSettings.openAppSettings();
          },ok: "فتح اعدادات التطبيق" );
    }else if(status.isProvisional){
      print("isProvisional");
    }else if(status.isRestricted){
      print("isRestricted");
    }
  }

  Future<void> requestPermmission() async {
     // We haven't asked for permission yet or the permission has been denied before, but not permanently.']
    await Permission.camera
        .onDeniedCallback(() {
      // Your code
      print("onDeniedCallback");
    })
        .onGrantedCallback(() {
      showUnityInSameScreen();
    })
        .onPermanentlyDeniedCallback(() {
          print("onPermanentlyDeniedCallback");
      // Your code
    })
        .onRestrictedCallback(() {
      // Your code
      print("onRestrictedCallback");
    })
        .onLimitedCallback(() {
      // Your code

      print("onLimitedCallback");
    })
        .onProvisionalCallback(() {
      // Your code
      print("onProvisionalCallback");
    })
        .request();
  }

  void showUnityInSameScreen() {
     setState(() {
      index=2;
    });
  }
}
