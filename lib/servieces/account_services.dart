import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/models/account.dart';


class AccountServices {


  Future<String> createFollow(String followerID, String userID) async {
    Completer<String> completer = Completer<String>();

    try {
      CollectionReference follows = FirebaseFirestore.instance.collection('Follows');

      Map<String, dynamic> follow = {
        'follower_id': followerID,
        'user_id': userID,
        'notification_id': ""
      };

      DocumentReference followDocRef = await follows.add(follow);
      String followID = followDocRef.id;

      CollectionReference notifications = FirebaseFirestore.instance.collection('Notifications');
      Account userLogin = await AccountServices.getUserLogin();
      Object user = {
        'user_id': userLogin.userID,
        'avatar_url': userLogin.userName,
        'user_name': userLogin.avatarUrl,
      };
      Map<String, dynamic> notification = {
        'content': "Đã bắt đầu theo dõi bạn",
        'date_notification': DateTime.now(),
        'status': false,
        'type': 2,
        'user_id': userID,
        'user': user,
        'video_id': ""
      };

      DocumentReference notificationDocRef = await notifications.add(notification);
      String notificationID = notificationDocRef.id;

      await follows.doc(followID).update({'notification_id': notificationID});

      completer.complete(followID);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }




  Future<void> deleteFollow(String followID) async {
    String notificationFollowID = "";
    DocumentReference followRef = FirebaseFirestore.instance.collection('Follows').doc(followID);
    DocumentSnapshot followSnapshot = await followRef.get();

    if (followSnapshot.exists) {
      Map<String, dynamic> followData = followSnapshot.data() as Map<String, dynamic>;
      notificationFollowID = followData['notification_id'];

      // Xóa tài liệu Follow
      await followRef.delete();
      if (notificationFollowID.isNotEmpty) {
        DocumentReference followNotiRef = FirebaseFirestore.instance.collection('Notifications').doc(notificationFollowID);
        DocumentSnapshot followNotiSnapshot = await followNotiRef.get();

        if (followNotiSnapshot.exists) {
          await followNotiRef.delete();
        }
      }
    }
  }



  static getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Account(
        prefs.getString('user_id') ?? "",
        prefs.getString('user_name') ?? "",
        prefs.getString('avatar_url') ?? "", "", "");
  }
}
