import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servieces/account_services.dart';

class FollowButton extends StatefulWidget {
  String userID;
  String userLoginID;

  FollowButton({super.key, required this.userID, required this.userLoginID});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool? _isFollowingUser;

  String _idFollowOfUserLogin = '';

  _checkFollowedUser() async {
    AccountServices()
        .checkFollowExists(widget.userLoginID, widget.userID)
        .then((result) {
          if(result != ''){
            _idFollowOfUserLogin = result;
            setState(() {
              _isFollowingUser = true;
            });
          }
          else{
            setState(() {
              _isFollowingUser = false;
            });
          }

    });
  }

  _handelCreateFollow(){
    AccountServices()
        .createFollow(widget.userLoginID, widget.userID)
        .then((followID) {
      _idFollowOfUserLogin = followID;
      setState(() {
        _isFollowingUser = true;
      });
    }).catchError((error) {
      // Xử lý khi có lỗi xảy ra
    });
  }

  _handleDeleteFollow(){
    AccountServices()
        .deleteFollow(_idFollowOfUserLogin!)
        .then((_) {
      setState(() {
        _isFollowingUser = false;
      });
    }).catchError((error) {
      // Xử lý khi có lỗi xảy ra
    });

  }

  @override
  void initState() {
    _checkFollowedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: _isFollowingUser == null
          ? Container()
          : Container(
              // padding:
                  // const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              child: InkWell(
                onTap: () {
                  if (!_isFollowingUser!) {
                   _handelCreateFollow();
                  } else {
                    _handleDeleteFollow();
                  }
                },
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      color: !_isFollowingUser!
                          ? Colors.redAccent
                          : CupertinoColors.white),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          !_isFollowingUser! ? "Theo dõi" : "Bỏ theo dõi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontSize: 15,
                              color: !_isFollowingUser!
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          !_isFollowingUser!
                              ? CupertinoIcons.plus
                              : CupertinoIcons.xmark,
                          color:
                              !_isFollowingUser! ? Colors.white : Colors.black,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
