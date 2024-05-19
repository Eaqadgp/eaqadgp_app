import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:eaqad_app/ui/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../home/main_page.dart';

class BuyyerProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const BuyyerProfile({super.key, required this.data});

  @override
  State<BuyyerProfile> createState() => _BuyyerProfileState();
}

class _BuyyerProfileState extends State<BuyyerProfile> {
  var key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController verifyPassword = TextEditingController();
  TextEditingController phoneCode = TextEditingController();
  double width = 300;
  bool loading = false;
  String currentEmail = "";
  String currentPassword = "";

  @override
  void initState() {
    setState(() {
      phoneCode.text = widget.data['phone'];
      lastName.text = widget.data['lastName'];
      firstName.text = widget.data['firstName'];
      password.text = widget.data['password'];
      email.text = widget.data['email'];
      currentEmail = widget.data['email'];
      currentPassword = widget.data['password'];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurryModalProgressHUD(
        inAsyncCall: loading,
        blurEffectIntensity: 8,
        progressIndicator: const CircularProgressIndicator(),
        dismissible: false,
        opacity: 0.4,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
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
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsets.all(12),
                              color: Colors.white70,
                              height: 40,
                              width: double.infinity,
                              child: Center(
                                child: Text("الملف الشخصي"),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                            updateUserInfo();

                            //showConfirmEmailDialog();
                          },
                          child: Text(
                            'حفظ التعديلات',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
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

  void updateUserInfo() async {
    if (key.currentState!.validate()) {
      if (currentPassword == password.text && currentEmail == email.text) {
        // update User only
        updateUser();
      } else if (currentEmail != email.text &&
          currentPassword == password.text) {
        // change OnlyEmail
        changeEmail();
      } else if (currentEmail == email.text &&
          currentPassword != password.text) {
        // change only password
        changePassword();
      } else {
        // change email and password
        changeEmailAndPassword();
      }
    }
  }

  changeEmail() async {
    setState(() {
      loading = true;
    });
    try{
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);
      UserCredential userCredential=await user!.reauthenticateWithCredential(authCredential);
      if(userCredential.user!=null){
        await user.verifyBeforeUpdateEmail(email.text);
        var map = {
        //email": email.text,
          "password": password.text,
          "firstName": firstName.text,
          "lastName": lastName.text,
          "phone": phoneCode.text,
        };
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).update(map);
        setState(() {
          loading = false;
        });
        user.reload();
        showSuccessUpdate();
        showConfirmEmailDialog();

      }else{
        setState(() {
          loading=false;
        });
        showErrorUpdateProfile();
        showConfirmEmailDialog();

      }
    }catch(e){
      setState(() {
        loading=false;

      });
      showErrorUpdateProfile();
    }

  }

  void showConfirmEmailDialog() async{
    if (await confirm(
      context,
      title: const Text('تنبيه',textAlign: TextAlign.right,),
      content: const Text('لقد قمت بتغيير البريد الالكتروني يرجى النفر على الرابط المرسل في بريدك ليتم تجديثه',textAlign: TextAlign.right,style: TextStyle(fontSize: 22,color: Colors.black),),
      textOK: const Text('حسنا',textAlign: TextAlign.right,),
      textCancel: const Text('اغلاق',textAlign: TextAlign.right,),
    )) {
      return print('pressedOK');
    }
    return print('pressedCancel');
  }
  changePassword() async {
    setState(() {
      loading = true;
    });
    try{
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);
      UserCredential userCredential=await user!.reauthenticateWithCredential(authCredential);
      if(userCredential.user!=null){
        await user.updatePassword(password.text);
        var map = {
         // "email": email.text,
          "password": password.text,
          "firstName": firstName.text,
          "lastName": lastName.text,
          "phone": phoneCode.text,
        };
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).update(map);
        setState(() {
          loading = false;
        });
        user.reload();
        showSuccessUpdate();
      }else{
        setState(() {
          loading=false;
        });
        showErrorUpdateProfile();

      }
    }catch(e){
      setState(() {
        loading=false;

      });
      showErrorUpdateProfile();
    }

  }

  changeEmailAndPassword() async {
    setState(() {
      loading = true;
    });
    try{
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);
      UserCredential userCredential=await user!.reauthenticateWithCredential(authCredential);
      if(userCredential.user!=null){
        print(user.emailVerified);
        await user.verifyBeforeUpdateEmail(email.text);

        user.reload();

        // starting updating Password
        User? user1 = FirebaseAuth.instance.currentUser;
        AuthCredential authCredential1 = EmailAuthProvider.credential(
            email: currentEmail, password: currentPassword);
        UserCredential userCredential1=await user.reauthenticateWithCredential(authCredential1);
        if(userCredential1.user!=null){
          await user1!.updatePassword(password.text);
          var map = {
           //"email": email.text,
            "password": password.text,
            "firstName": firstName.text,
            "lastName": lastName.text,
            "phone": phoneCode.text,
          };
          String uid = FirebaseAuth.instance.currentUser!.uid;
          await FirebaseFirestore.instance.collection("users").doc(uid).update(map);
          setState(() {
            loading = false;
          });
          user.reload();
          showSuccessUpdate();
          showConfirmEmailDialog();
        }else{
          setState(() {
            loading=false;
          });
          showErrorUpdateProfile();
        }

      }else{
        setState(() {
          loading=false;
        });
        showErrorUpdateProfile();

      }
    }catch(e){
      setState(() {
        loading=false;

      });
      showErrorUpdateProfile();
    }

  }

  void updateUser() async {
    setState(() {
      loading = true;
    });
    try {
      var map = {
        "email": email.text,
        "password": password.text,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "phone": phoneCode.text,
      };
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(uid).update(map);
      setState(() {
        loading = false;
      });
      showSuccessUpdate();
    } catch (e) {
      setState(() {
        loading = false;
      });
      showErrorUpdateProfile();
    }
  }

  void showSuccessUpdate() {
     final snackbar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: "تم التعديل",
        message: "تم تعديل الملف الشخصي بنجاح",
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void showErrorUpdateProfile() {
     final snackbar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: "خطا",
        message: "حدث خطا اثناء تعديل الملف الشخصي",
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
