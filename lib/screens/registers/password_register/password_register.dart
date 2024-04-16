import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:y_videos/screens/registers/name_register/name_register.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:y_videos/servieces/color_services.dart';


import '../../../models/account.dart';
import '../../../servieces/custom_vietnamese_pw_validation.dart';

class PasswordRegister extends StatefulWidget {
  @override
  State<PasswordRegister> createState() => _PasswordRegisterState();
}

class _PasswordRegisterState extends State<PasswordRegister> {
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();





  bool _isShowPassword = false;
  bool _isButtonEnabled = false;



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
            const SizedBox(
              height: 20,
            ),
            const Text("Mật khẩu của bạn phải bao gồm ít nhất:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 16),),

            FlutterPwValidator(
              key: validatorKey,
              controller: _passwordController,
              minLength: 6,
              uppercaseCharCount: 1,
              numericCharCount: 1,
              specialCharCount: 1,
              width: 400,
              height: 200,
              strings: CustomVietnamesePwValidation(),

              onSuccess: () {
                setState(() {
                  _isButtonEnabled = true;
                });
              },
              onFail: () {
                setState(() {
                  _isButtonEnabled = false;
                });

              },
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







