import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs ;

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 2), () {
      _checkLogin();
      // Navigator.pushReplacementNamed(context, '/main-screens');

    });
    super.initState();
  }

  void _checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    String email_user = this.prefs.getString('user_id') ?? "";


    if(email_user != ""){
      Navigator.pushReplacementNamed(context, '/main-screens');
      print(email_user);
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Login()));
    }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'assets/images/big-logo2.png',
                      width: 200,
                      // height: 200,
                    ),
                  ),
                ),
                CircularProgressIndicator()
              ],
            )));
  }
}
