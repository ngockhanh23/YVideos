import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';

import '../../../../servieces/account_services.dart';
import '../../../../servieces/custom_vietnamese_pw_validation.dart';

class EditPasswordProfile extends StatefulWidget {
  @override
  State<EditPasswordProfile> createState() => _EditPasswordProfileState();
}

class _EditPasswordProfileState extends State<EditPasswordProfile> {
  bool _isButtonEnabled = false;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();

  _saveUpdatePasswordUser() async {
    if (!await AccountServices().checkCurrentUserPassword(_oldPasswordController.text)) {
      DialogHelper.warningAlertDialog(context, "Mật khẩu cũ không chính xác", "Thử lại");
    } else {
      // DialogHelper.successAlertDialog(context, "Mật khẩu đúng", "mật khẩu cũ chính xác");
      AccountServices().changePassword(_newPasswordController.text).then((_) {
        DialogHelper.successToastSnackbar(context, "Cập nhật mật khẩu thành công", 3);
        Navigator.pop(context);
      });
    }
  }

  void updateButtonState() {
    setState(() {
      if (_oldPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty) {
        _isButtonEnabled = true;
      } else {
        _isButtonEnabled = false;
      }
    });
  }

  @override
  void initState() {
    _oldPasswordController.addListener(updateButtonState);
    _newPasswordController.addListener(updateButtonState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text("Mật khẩu"),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(4.0), // Độ dày của đường gạch dưới
              child: Container(
                color: Colors.black26, // Màu của đường gạch dưới
                height: 0.2,
              ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mật khẩu mới",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                TextField(
                    // controller: _nameController,
                    obscureText: true,

                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                      hintText: "Mật khẩu cũ",
                      prefixIcon: Icon(Icons.lock_outline),
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
                        // this._nameController.text= "";
                        _oldPasswordController.text = "";
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black45,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                TextField(
                    obscureText: true,
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      hintText: "Mật khẩu mới",
                      prefixIcon: Icon(Icons.lock_outline),

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
                        // this._nameController.text= "";
                        _newPasswordController.text = "";
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black45,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
            ),
            FlutterPwValidator(
              key: validatorKey,
              controller: _newPasswordController,
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
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isButtonEnabled ? null : () => _saveUpdatePasswordUser(),
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
                child: const Text("Lưu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
