import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/components/follow_button/follow_button.dart';
import 'package:y_videos/screens/profile/profile_videos/profile_videos.dart';
import 'package:y_videos/servieces/account_services.dart';
import '../../models/account.dart';

class Profile extends StatelessWidget {
  Account account;
  bool isUserLogin;

  Profile({super.key, required this.account, required this.isUserLogin});

  // Account? account ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (account != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            AccountInformation(
              account: account,
              isUserLogin: isUserLogin,
            ),
            ProfileVideos(
              userID: account.userID,
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Container(
          child: const CircularProgressIndicator(),
        ),
      );
    }
  }
}

class AccountInformation extends StatefulWidget {
  Account account;
  bool isUserLogin;

  AccountInformation(
      {super.key, required this.account, required this.isUserLogin});

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  // List<Follow> lstFollows = [];
  int followerCount = 0;
  int followingCount = 0;

  // List<Follow> lstFollings = [];
  // Map<String, dynamic> user = {};
  // String? userLoginID;
  Account? userLogin;

  @override
  void initState() {
    getUserLogin();
    getAccountFollower();
    getAccountFollowing();
    super.initState();
  }

  getUserLogin() async {
    userLogin = await AccountServices.getUserLogin();
  }

  getAccountFollower() {
    FirebaseFirestore.instance
        .collection('Follows')
        .where('user_id', isEqualTo: widget.account.userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['follower_id'] == userLogin?.userID &&
            doc['user_id'] == widget.account.userID) {}
        followerCount++;
      }
      setState(() {
        // lstFollows = lstFollowsTemp;
      });
    }).catchError((error) {
      print("Error querying documents: $error");
    });
  }

  getAccountFollowing() {
    FirebaseFirestore.instance
        .collection('Follows')
        .where('follower_id', isEqualTo: widget.account.userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        followingCount++;
      }
      setState(() {});
    }).catchError((error) {
      print("Error querying documents: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return userLogin == null
        ? Container()
        : Container(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    widget.account.avatarUrl.toString(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '@${widget.account.userID}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  widget.account.userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            followingCount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Text(
                            "Đang Follow",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            followerCount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Text(
                            "Follower",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "91",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Text(
                            "Likes",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                widget.isUserLogin
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                await Navigator.pushNamed(
                                        context, "/edit-profile")
                                    .then((value) {
                                  getUserLogin();
                                });
                              },
                              child: Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12)),
                                child: const Center(
                                  child: Text(
                                    "Chỉnh sửa hồ sơ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: Container(
                                height: 45,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12)),
                                child: Center(
                                  child: Icon(Icons.bookmark_border_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: SizedBox(
                            width: 200,
                            child: FollowButton(
                              userID: widget.account.userID,
                              userLoginID: userLogin!.userID,
                            )))
              ],
            ),
          );
  }
}
