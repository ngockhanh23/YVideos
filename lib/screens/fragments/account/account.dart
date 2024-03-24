import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/servieces/account_services.dart';

import '../../login/login.dart';

class AccountFragment extends StatefulWidget {
  @override
  State<AccountFragment> createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  @override
  void initState() {
    getUserLogin();
    super.initState();
  }

  // late SharedPreferences prefs;
  Account? account;

  getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Sử dụng biến prefs tại cấp độ lớp

    String? userID = prefs.getString('user_id');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('userID', isEqualTo: userID).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

      setState(() {
        account = Account(
          userData['userID'].toString(),
          userData['userName'].toString(),
          userData['avatarUrl'].toString(),
          userData['userEmail'].toString(),
          "",
        );
      });

      // authService.account = account; // Nếu cần thiết
    } else {
      print('Không tìm thấy người dùng với id này.');
    }
  }

  void _logOut(BuildContext context) async {
    AccountServices().signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Tôi"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('Đăng xuất'),
                          onTap: () {
                            _logOut(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.list_outlined),
          )
        ],
      ),
      body: account == null ? Container() : Profile(account: account!,isUserLogin: true,),
    );
  }
}
