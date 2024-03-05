import 'package:flutter/material.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/servieces/account_services.dart';

class EditNameProfile extends StatefulWidget {
  @override
  State<EditNameProfile> createState() => _EditNameProfileState();
}

class _EditNameProfileState extends State<EditNameProfile> {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null && ModalRoute.of(context)!.settings.arguments != null) {
      _nameController.text = ModalRoute.of(context)!.settings.arguments as String;
    }
  }

  _saveUpdateNameUser(){
    AccountServices().editNameUser(_nameController.text).then((_) {
      DialogHelper.successToastSnackbar(context, "Cập nhật tên người dùng thành công", 3);
      Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Tên"),
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
                Text("Tên", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                Stack(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),)
                    ),
                    Positioned(
                      right: 0,
                        child: IconButton(
                          onPressed: () {
                            this._nameController.text= "";
                          },
                          icon: Icon(Icons.cancel, color: Colors.black45,),
                        ))
                  ],
                ),

                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !_isButtonEnabled ? null : () => _saveUpdateNameUser(),
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
                )
              ],
            ),
          ),
    );
  }
}
