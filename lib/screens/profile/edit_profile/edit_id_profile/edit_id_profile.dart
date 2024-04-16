import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:y_videos/servieces/account_services.dart';
import 'package:y_videos/servieces/color_services.dart';

import '../../../../components/dialog_helper/dialog_helper.dart';
import '../../../../models/account.dart';


class EditIDProfile extends StatefulWidget{
  @override
  State<EditIDProfile> createState() => _EditIDProfileState();
}

class _EditIDProfileState extends State<EditIDProfile> {

  TextEditingController _idController = TextEditingController();
  bool _isButtonEnabled = false;
  String _idUserLogin = "";



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

  _updateID() async {
    if(_idUserLogin == _idController.text.trim()){
      Navigator.pop(context);
      return;
    }
    if ( await AccountServices().checkIDExists(_idController.text.trim())) {
      DialogHelper.warningAlertDialog(context, "Đã có người sử dụng Yvideo ID này", "Thử với ID khác");
    } else {
      AccountServices().editIdUser(_idController.text.trim()).then((_) {
        DialogHelper.successToastSnackbar(context, "Cập nhật YVideoID người dùng thành công", 3);

        Navigator.pop(context);
      });
    }
  }



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
  void didChangeDependencies() {

    super.didChangeDependencies();
    if (ModalRoute.of(context) != null && ModalRoute.of(context)!.settings.arguments != null) {
      _idController.text = ModalRoute.of(context)!.settings.arguments as String;
      _idUserLogin = _idController.text;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("YVideo ID"),
          centerTitle: true,),
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
            SizedBox(
              height: 20,
            ),
            // Text("Sử dụng Email của bạn để đăng ký sử dụng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isButtonEnabled ? null : () => _updateID(),
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
      )
    );
  }
}