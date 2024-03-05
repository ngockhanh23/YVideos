import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/screens/registers/email_register/email_register.dart';


import '../../components/dialog_helper/dialog_helper.dart';
import '../../models/account.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences prefs ;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'assets/images/big-logo2.png',
                width: 200,
              ),
            ),
            const Text(
              "Hãy đăng nhập để kết nối với mọi người",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ),
                    onPressed: () => _onLogin(context),
                    child: Text("Đăng nhập"),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, '/register');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmailRegister()),
                        );
                      },
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: InkWell(
                  //     onTap: (){
                  //       // Navigator.pushNamed(context, '/register');
                  //     },
                  //     child: Text("Quên mật khẩu ?", style: TextStyle(color: Colors.black54)),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  _onLogin(BuildContext context) async {
    try {
      await this._auth.signInWithEmailAndPassword(email: this._emailController.text.trim(), password: this._passwordController.text.trim());
      print('đăng nhập thành công');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: this._emailController.text).limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

        this.prefs = await SharedPreferences.getInstance();
        // querySnapshot.docs.first.id
        prefs.setString('id_user_doc', querySnapshot.docs.first.id.toString());
        prefs.setString('user_id', userData['userID'].toString());
        prefs.setString('user_name', userData['userName'].toString());
        prefs.setString('avatar_url', userData['avatarUrl'].toString());




      } else {
        print('Không tìm thấy người dùng với email này.');
      }

      Navigator.pushReplacementNamed(context, '/main-screens');
    } catch (e) {
      DialogHelper.warningAlertDialog(context, "Sai thông tin email hoặc mật khẩu", "Ok");
    }

  }
}
