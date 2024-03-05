import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/dialog_helper/dialog_helper.dart';
import '../../../models/account.dart';

class NameRegister extends StatefulWidget{

  @override
  State<NameRegister> createState() => _NameRegisterState();
}

class _NameRegisterState extends State<NameRegister> {
  TextEditingController _nameController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    _nameController.addListener(() {
      // print(_emailController.text);
      setState(() {
        _nameController.text != "" ? this._isButtonEnabled = true : this._isButtonEnabled = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Account account = ModalRoute.of(context)?.settings.arguments as Account;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tạo tên",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            const Text(
              "Bạn có thể sử dụng bất kỳ tên nào mình thích và có thể thay đổi về sau",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),

            Stack(
              children: [
                TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Nhập tên của bạn",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    )),
                Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        this._nameController.text = "";
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black45,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Text("Sử dụng Email của bạn để đăng ký sử dụng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isButtonEnabled ? null : () => _handleRegister(context, account),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.redAccent;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
                child: const Text("Đăng ký ngay"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleRegister(BuildContext context, Account account) async {
    account.userName = this._nameController.text;

    try {
      // Đăng ký tài khoản trong Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: account.email,
        password: account.password,
      );
      // var user = userCredential.user;


      await FirebaseFirestore.instance.collection('Users').doc().set({
        'email': account.email,
        'userName' : account.userName,
        'userID' : account.userID,
        'avatarUrl' : 'https://youna.ru/assets/guest/img/author-stub.png',
        'search_history' : []
      });

      Navigator.pushReplacementNamed(context, '/login');


      DialogHelper.successToastSnackbar(context, "Đăng ký thành công", 3);



    } catch (e) {

      print('Đã xảy ra lỗi khi đăng ký: $e');
    }
  }


}