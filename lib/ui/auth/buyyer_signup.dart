import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:eaqad_app/ui/auth/login.dart';
import 'package:eaqad_app/ui/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../home/main_page.dart';

class BuyyerSignUp extends StatefulWidget {
  const BuyyerSignUp({super.key});

  @override
  State<BuyyerSignUp> createState() => _BuyyerSignUpState();
}

class _BuyyerSignUpState extends State<BuyyerSignUp> {
  var key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController verifyPassword = TextEditingController();
  TextEditingController phoneCode = TextEditingController();
  double width = 300;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: BlurryModalProgressHUD(
          inAsyncCall: loading,
          blurEffectIntensity: 8,
          progressIndicator: const CircularProgressIndicator(),
          dismissible: false,
          opacity: 0.4,
          color: Theme.of(context).primaryColor,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Form(
                key: key,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: firstName,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضلا اكتب الاسم الاول";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'الاسم الاول',
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
                      TextFormField(
                        controller: lastName,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضلا اكتب الاسم الاخير";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'الاسم الاخير',
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
                      TextFormField(
                        controller: email,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضلا اكتب البريد الالكتروني";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
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
                      new SizedBox(height: 10.0),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضبلا اكتب كلمة المرور";
                          }
                          if (v!.length < 8) {
                            return "طول كلمة المرور لايقل عن 8";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
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
                      TextFormField(
                        obscureText: true,
                        controller: verifyPassword,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضلا اكتب تأكيد كلمة المرور";
                          }
                          if (v!!=password.text) {
                            return "كلمة المرور غيرمتطابقة";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'تأكيد الرمز',
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
                      TextFormField(
                        controller: phoneCode,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "فضلا اكتب رقم الهاتف";
                          }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: 'رقم الهاتف',
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
                       AnimatedContainer(
                              width: width as double,
                              duration: Duration(seconds: 1),
                              child: ElevatedButton(
                                onPressed: () {
                                  signUp();
                                },
                                child: Text(
                                  'تسجيل الحساب',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  minimumSize: Size.fromHeight(50),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (key.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try{
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email.text, password: password.text);

        if (userCredential.user == null) {
          setState(() {
            loading = false;
          });
          final snackbar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "خطا",
              message: "خطا في انشاء الحساب يرجى المحاولة مرة اخرى",
              contentType: ContentType.failure,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackbar);

        }else{
          var data = {
            "email": email.text,
            "password": password.text,
            "firstName": firstName.text,
            "lastName": lastName.text,
            "phone": phoneCode.text,
            "id": userCredential.user!.uid,
            "type": "buyyer"
          };
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set(data);


          if(userCredential.user!.emailVerified==true){
            setState(() {
              loading = false;
            });
            final snackbar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: "انشاء الحساب",
                message: "تم انشاء الحساب بنجاح",
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
          }else{
            setState(() {
              loading = false;
            });
            FirebaseAuth.instance.setLanguageCode("ar");
            await userCredential.user!.sendEmailVerification();
            showConfirmEmailDialog();

          }

        }

      }catch(e){
        setState(() {
          loading = false;
        });
        final snackbar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "خطا",
            message: "خطا في انشاء الحساب يرجى المحاولة مرة اخرى",
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackbar);
      }


    }
  }
  void showConfirmEmailDialog() async{
    if (await confirm(
      context,
      title: const Text('تنبيه',textAlign: TextAlign.right,),
      content: const Text('يرجى تأكيد البريد الالكتروني من خلال الضغط على الرابط الذي تم ارساله على البريد للبدء باستخدام إعقاد',textAlign: TextAlign.right,style: TextStyle(fontSize: 22,color: Colors.black),),
      textOK: const Text('حسنا',textAlign: TextAlign.right,),
      textCancel: const Text('اغلاق',textAlign: TextAlign.right,),
    )) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (v)=>const Login()), (route) => false);
    }else{
      Navigator.pop(context);
    }

  }
}
