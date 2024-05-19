import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword ({super.key});

  @override
  State<ForgetPassword> createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
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
                         SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.topRight,
                          child:Text(
                            "سيتم إرسال رابط تعيين كلمة المرور على بريدك الالكتروني"
                          ) ,),


                        SizedBox(height: 20.0),
                        AnimatedContainer(
                          width: width as double,
                          duration: Duration(seconds: 1),
                          child: ElevatedButton(
                            onPressed: () {
                              send();
                              //callNativeMethod();
                            },
                            child: Text(
                              'ارسال',
                              style: TextStyle(color: Colors.white,fontSize: 22),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size.fromHeight(50),
                            ),
                          ),
                        ),
                        new SizedBox(height: 10.0),


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

  void send() async{
    if(key.currentState!.validate()){
      setState(() {
        loading=true;
      });
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        setState(() {
          loading=false;
        });
          final snackbar=SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "تم الارسال",
              message: "تم ارسال رابط تعيين كلمة المرور, يرجى تفقد صندوق الوارد",
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);


      }catch(e){
        setState(() {
          loading=false;
        });
        final snackbar=SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "خطا",
            message: "تاكد من البريد الالكتروني / البريد الالكتروني غير مسجل لدينا",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);
      }


    }
  }
}

