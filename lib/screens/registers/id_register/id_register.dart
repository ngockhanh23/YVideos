import 'package:flutter/material.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/registers/password_register/password_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class IDRegister extends StatefulWidget {
  @override
  State<IDRegister> createState() => _IDRegisterState();
}

class _IDRegisterState extends State<IDRegister> {


  TextEditingController _userController = TextEditingController();
  bool _isButtonEnabled = false;


  Future<bool> checkIDExists(String idUser) async {
    try {
      // Thực hiện truy vấn trong Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userID', isEqualTo: idUser)
          .get();

      return querySnapshot.docs.isNotEmpty;

    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }



  @override
  void initState() {
    _userController.addListener(() {
      // print(_emailController.text);
      setState(() {
        _userController.text != "" ? this._isButtonEnabled = true : this._isButtonEnabled = false;
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
                    controller: _userController,
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
                const Text(
                  "Mỗi ID là một định danh duy nhất để có thể dể dàng tìm kiếm và truy cập và bạn có thể thay đổi về sau",
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        this._userController.text = "";
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
                onPressed: !_isButtonEnabled ? null : () => _onCheckIDUser(context, account),
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

  _onCheckIDUser(BuildContext context, Account account) async {
    if (await checkIDExists(_userController.text)) {
      DialogHelper.warningAlertDialog(context, "Đã có người sử dụng Yvideo ID này", "Thử với ID khác");
    } else {
      // Account account = Account.empty();
      account.userID = _userController.text;

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
  }
}
