import 'package:flutter/material.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/registers/password_register/password_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:y_videos/servieces/color_services.dart';

import '../../../servieces/account_services.dart';


class IDRegister extends StatefulWidget {
  @override
  State<IDRegister> createState() => _IDRegisterState();
}

class _IDRegisterState extends State<IDRegister> {


  TextEditingController _idController = TextEditingController();
  bool _isButtonEnabled = false;






  @override
  void initState() {
    _idController.addListener(() {
      // print(_emailController.text);
      setState(() {
        _idController.text != "" ? this._isButtonEnabled = true : this._isButtonEnabled = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Account account = ModalRoute.of(context)?.settings.arguments as Account;

    // TODO: implement build


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
            // Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
            Stack(
              children: [
                TextField(
                    controller: _idController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Tạo Yvideo ID cho tài khoản dùng của bạn",
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
                        this._idController.text = "";
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black45,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Mỗi ID là một định danh duy nhất để có thể dể dàng tìm kiếm và truy cập và bạn có thể thay đổi về sau",
              softWrap: true,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),

            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isButtonEnabled ? null : () => _onCheckIDUser(context, account),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return ColorServices.primaryColor;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
                child: const Text("Tiếp"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onCheckIDUser(BuildContext context, Account account) async {
    if (await AccountServices().checkIDExists(_idController.text.trim())) {
      DialogHelper.warningAlertDialog(context, "Đã có người sử dụng Yvideo ID này", "Thử với ID khác");
    } else {
      account.userID = _idController.text.trim();

      if(account.userName.isEmpty){

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordRegister(),
            settings: RouteSettings(
              arguments: account,
            ),
          ),
        );
      }
      else{
        // print('user name' + account.userName);
        // Navigator.pop(context);
        DocumentReference docRef = await AccountServices().registerInFirestore(account);


        DocumentSnapshot snapshot = await docRef.get();


        print('Document ID: ${snapshot.id}');


        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          Account account = Account(data['userID'], data['userName'], data['avatarUrl'], data['email'], '');
          AccountServices().loginHandle(account, snapshot.id).then((_) {
            Navigator.pop(context);
          });
          
        } else {
          print('Không có dữ liệu.');
        }

        // AccountServices().loginHandle(account, idUserDoc)
      }
    }
  }
}
