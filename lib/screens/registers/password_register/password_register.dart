import 'package:flutter/material.dart';
import 'package:y_videos/screens/registers/name_register/name_register.dart';

import '../../../models/account.dart';

class PasswordRegister extends StatefulWidget {
  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class _PasswordRegisterState extends State<PasswordRegister> {
  TextEditingController _passwordController = TextEditingController();

  bool _checkPasswordLength = false;
  bool _checkPasswordContainingDigit = false;
  bool _checkPasswordContainingSpecialCharacter = false;

  bool _isShowPassword = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
      _passwordController.addListener(() {
        setState(() {
          _checkPasswordLength = this._passwordController.text.length >= 8;
          _checkPasswordContainingDigit = this._passwordController.text.contains(RegExp(r'\d'));
          _checkPasswordContainingSpecialCharacter = _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
          if(_checkPasswordLength && _checkPasswordContainingDigit && _checkPasswordContainingSpecialCharacter){
            // _passwordController.text != "" ? this._isButtonEnabled = true : this._isButtonEnabled = false;
            this._isButtonEnabled = true;
          } else {
            this._isButtonEnabled = false;
          }
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
            Text(
              "Tạo mật khẩu",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
            Stack(
              children: [
                TextField(
                    controller: _passwordController,
                    obscureText: !this._isShowPassword,

                    decoration: const InputDecoration(
                      hintText: "Nhập mật khẩu",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    )),
                Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            this._passwordController.text = "";
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black45,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // this._passwordController.text = "";
                            setState(() {
                              !this._isShowPassword ? this._isShowPassword = true : this._isShowPassword = false;
                            });
                          },
                          icon: this._isShowPassword ? Icon(
                            Icons.vpn_key_outlined,
                            color: Colors.black45,
                            size: 30,
                          ) :
                          Icon(
                            Icons.key_off_outlined,
                            color: Colors.black45,
                            size: 30,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            const Text("Mật khẩu của bạn phải bao gồm ít nhất:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 16),),
            
            Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color:  !this._checkPasswordLength ? Colors.black54 : Colors.green,

                  ),
                  const Text("8 ký tự", style: TextStyle(fontSize: 16),),
                ],
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color:  !this._checkPasswordContainingDigit ? Colors.black54 : Colors.green,
                ),
                const Text("Bao gồm chữ số", style: TextStyle(fontSize: 16),),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color:  !this._checkPasswordContainingSpecialCharacter ? Colors.black54 : Colors.green,

                ),
                const Text("Có chứa ký tự đặc biệt", style: TextStyle(fontSize: 16),),
              ],
            ),

            const SizedBox(height: 12),

            
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isButtonEnabled ? null : () {
                  account.password = this._passwordController.text;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NameRegister(),
                        settings: RouteSettings(
                          arguments: account,
                        )
                    ),

                  );

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (Set states) {
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
                // Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),

                child: const Text("Tiếp"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
