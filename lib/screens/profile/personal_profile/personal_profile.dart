import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/profile/profile.dart';

class PersonalProfile extends StatefulWidget{
  String userID;
  PersonalProfile({super.key, required this.userID});

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  Account? account;
  bool statusLoginProfile = false;

  @override
  void initState() {
    getAccount();
    super.initState();
  }

  getAccount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('user_id') ?? "";

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('userID', isEqualTo: widget.userID).limit(1).get();
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

        if(userID == userData['userID'].toString()){
          statusLoginProfile = true;
        }
      });
      // authService.account = account; // Nếu cần thiết
    } else {
      print('Không tìm thấy người dùng với id này.');
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile") ,
      ),
      body: account == null ? CircularProgressIndicator() : Profile(account: account!,isUserLogin: statusLoginProfile,),
    );
  }
}