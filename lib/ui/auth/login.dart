

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:eaqad_app/ui/auth/forget_password.dart';
import 'package:eaqad_app/ui/auth/signup.dart';
import 'package:eaqad_app/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/main_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var key=GlobalKey<FormState>();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  double width = 400;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromRGBO(182, 208, 238, 1.0),

      body: BlurryModalProgressHUD(
        inAsyncCall: loading,
        blurEffectIntensity: 8,
        progressIndicator: const CircularProgressIndicator(),
        dismissible: false,
        opacity: 0.4,
        color: Theme.of(context).primaryColor,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(

                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(top: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Form(key: key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logo.png",height: 150,),
        
        
        
                        TextFormField(
                          controller: email,
                          validator: (v){
                            if(v!.isEmpty){
                              return "فضلا اكتب البريد الالكتروني";
                            }
        
                          },
                          style: TextStyle(height: 1),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),
                              hintText: 'البريد الالكتروني',
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Color.fromARGB(255, 241, 241, 241),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 241, 241, 241),
                                  ))),
                        ),
                        new SizedBox(height: 20.0),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          validator: (v){
                            if(v!.isEmpty){
                              return "فضبلا اكتب كلمة المرور";
                            }
                            if(v!.length<8){
                              return "طول كلمة المرور لايقل عن 8";
                            }
                          },
                          style: TextStyle(height: 1),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,),
                              hintText: 'كلمة المرور',
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Color.fromARGB(255, 241, 241, 241),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 241, 241, 241),
                                  ))),
                        ),
        
                        new SizedBox(height: 10.0),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=>const ForgetPassword()));
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              'هل نسيت كلمة المرور؟',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        new SizedBox(height: 10.0),
                        AnimatedContainer(
                          width: width as double,
                          duration: Duration(seconds: 1),
                          child: ElevatedButton(
                            onPressed: () {
                              login();
                              //callNativeMethod();
                            },
                            child: Text(
                              'تسجيل دخول',
                              style: TextStyle(color: Colors.white,fontSize: 22),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size.fromHeight(50),
                            ),
                          ),
                        ),
                        new SizedBox(height: 10.0),


                        new SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              ' ليس لديك حساب؟',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ));
                              },
                              child: Text(
                                'سجل الان',
                                style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
  var platform = MethodChannel('your_channel_name');
  Future<void> callNativeMethod() async {
    try {
      await platform.invokeMethod('nativeMethod');
    } catch (e) {
      print('Error calling native method: $e');
    }
  }

  void login() async{
    if(key.currentState!.validate()){
      setState(() {
        loading=true;
      });
      try{
        UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
        if(userCredential.user==null){
          setState(() {
            loading=false;
          });
          final snackbar=SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "خطا",
              message: "تاكد من البريد الالتكروني او كلمة المرور",
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);

        }else {
         // if(userCredential.user!.emailVerified==true){
            var data={"email":email.text,"password":password.text};
            FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).update(data);
            final snackbar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "تم",
                message: "تم تسجيل الدخول بنجاح",
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackbar);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ));
          // }else{
          //   FirebaseAuth.instance.setLanguageCode("ar");
          //   await userCredential.user!.sendEmailVerification();
          //   setState(() {
          //     loading = false;
          //   });
          //   showConfirmEmailDialog();
          // }

        }
      }catch(e){
        print(e);
        setState(() {
          loading=false;
        });
        final snackbar=SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "خطا",
            message: "تاكد من البريد الالتكروني او كلمة المرور",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);
      }


    }
  }

  void showConfirmEmailDialog() async{
    if (await confirm(
      context,
      title: const Text('تنبيه'),
      content: const Text('يرجى إثبات ملكية البريد الالكتروني من خلال الضغط على الرابط الذي تم ارساله إليك',style: TextStyle(fontSize: 22,color: Colors.black),),
      textOK: const Text('حسنا'),
      textCancel: const Text('اغلاق'),
    )) {
    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (v)=>const Login()), (route) => false);
    }else{
      Navigator.pop(context);
    }

  }
}
