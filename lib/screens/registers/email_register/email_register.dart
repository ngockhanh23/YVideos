import 'package:flutter/material.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/registers/id_register/id_register.dart';
import 'package:y_videos/screens/registers/password_register/password_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EmailRegister extends StatefulWidget {
  @override
  State<EmailRegister> createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {
  TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;


  Future<bool> checkEmailExists(String email) async {
    try {
      // Thực hiện truy vấn trong Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;

    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }



  @override
  void initState() {
    _emailController.addListener(() {
      // print(_emailController.text);
      setState(() {
        _emailController.text != "" ? this._isButtonEnabled = true : this._isButtonEnabled = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Địa chỉ email",
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
                        this._emailController.text = "";
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
                onPressed: !_isButtonEnabled ? null : () => _onCheckEmail(context),
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
                child: const Text("Tiếp"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onCheckEmail(BuildContext context) async {
    if (await checkEmailExists(_emailController.text)) {
      DialogHelper.warningAlertDialog(context, "Đã có người sử dụng email này", "Thử với Email khác");
    } else {
      Account account = Account.empty();
      account.email = _emailController.text;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IDRegister(),
          settings: RouteSettings(
            arguments: account,
          ),
        ),
      );
    }
  }
}
