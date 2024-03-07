import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/servieces/account_services.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Account? _userLogin;

  @override
  void initState() {
    _getUserLogin();
    super.initState();
  }

  _getUserLogin() async {
    _userLogin = await AccountServices.getUserLogin();
    if (_userLogin != null) {
      setState(() {});
    }
  }
  Future<void> _pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ContentReview(
      //           videoPath: result.files.single.path!,
      //         )));
      AccountServices().uploadImageToFirebase(result.files.single.path!).then((_){
          _getUserLogin();
          DialogHelper.successToastSnackbar(context, "Cập nhật ảnh đại diện thành công", 3);

      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tài khoản"),
        centerTitle: true,
      ),
      body: _userLogin! == null
          ? Container()
          : SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () => _changeImagesModalBottomSheet(context),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              _userLogin!.avatarUrl,
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Giới thiệu về bạn",
                      style: TextStyle(color: Colors.black45, fontSize: 15),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, "/edit-name-profile",
                          arguments: _userLogin!.userName
                      ).then((_) => _getUserLogin());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tên",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                _userLogin!.userName,
                                style: TextStyle(fontSize: 18, color: Colors.black54),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/edit-id-profile",
                          arguments: _userLogin!.userID
                      ).then((_) => _getUserLogin());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "YVideo ID",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                _userLogin!.userID,
                                style: TextStyle(fontSize: 18, color: Colors.black54),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/edit-password-profile", );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mật khẩu",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "**********",
                                style: TextStyle(fontSize: 18, color: Colors.black54),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _changeImagesModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _pickImage(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                "Chọn ảnh từ thư viện",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                Divider(
                  thickness: 0.3,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.black87,
                              ),
                              Text(
                                "Chụp ảnh",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                Divider(
                  thickness: 0.3,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Hủy",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }
}
