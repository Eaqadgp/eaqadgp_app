import 'package:eaqad_app/ui/auth/buyyer_signup.dart';
import 'package:flutter/material.dart';

import 'waseet_signup.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var screens=[WaseetSignUp(),BuyyerSignUp()];
  var _value=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20) ),
                color: Theme.of(context).primaryColor
              ),
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  child: Row(
                    children: [
                      tab(0, "الوسيط العقاري", 0),
                      tab(0, 'المشتري', 1),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(flex:1,child: screens[_value])
          ],
        ),
      ),

    );
  }

  Expanded tab(double i, String title, int value) {
    return Expanded(
      child: GestureDetector(
          onTap: () => setState(() => _value = value),
          child: Container(
            alignment: Alignment.center,
            height: 40,
            margin: EdgeInsets.only(right: i),
            // padding: EdgeInsets.symmetric(horizontal:20,vertical: 18),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                border: Border.all(
                    color: _value == value
                        ? Colors.lightBlueAccent
                        : Color.fromARGB(255, 241, 241, 241),
                    width: 2),
                ),
            // height: 16,
            // width: 16,
            // color: _value == 1 ? Colors.grey : Colors.transparent,
            child: Text(
              title,
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          )),
    );
  }

}
