import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({super.key});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  var key=GlobalKey();
  bool isFull=true;
  @override
  void dispose() {
    setState(() {
      isFull=false;
    });

   _unityWidgetController!.quit();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("امسح المخطط"),
      ),
      body: SafeArea(
        child: UnityWidget(
          onUnityCreated: onUnityCreated,
           key: key,
          fullscreen:false ,
          onUnitySceneLoaded: (s){
            print(s);
          },
          useAndroidViewSurface: true,
          onUnityUnloaded: (){
            print("Unloaded");
          },
        ),
      ),
    );
  }
  UnityWidgetController? _unityWidgetController;
  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
    print("created");
  }
}
