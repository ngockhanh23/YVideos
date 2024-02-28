import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account.dart';
import 'account_services.dart';

class CommentServices {

  Future<List<Map<String, dynamic>>> getCommentsByVideoID(String videoID) async {
    List<Map<String, dynamic>> comments = [];

    try {
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('Comments')
          .where('video_id', isEqualTo: videoID)
          .get();

      comments = commentSnapshot.docs.map((doc) {
        Map<String, dynamic> commentData = doc.data() as Map<String, dynamic>;
        commentData['id'] = doc.id;
        return commentData;
      }).toList();
    } catch (error) {
      print('Error getting comments: $error');
    }

    return comments;
  }

  Future<dynamic> createComment(String videoID, String commentContent) async {
    Completer<dynamic> completer = Completer<dynamic>();

    Account userLogin = await AccountServices.getUserLogin();
    Object user = {
      'user_id': userLogin?.userID,
      'user_name': userLogin?.userName,
      'avatar_url': userLogin?.avatarUrl,
    };

    Map<String, dynamic> commentItem = {
      'comment_content': commentContent,
      'date_comment': DateTime.now(),
      'number_of_likes': 0,
      'user': user,
      'video_id': videoID
    };

    DocumentReference docRef = await FirebaseFirestore.instance.collection('Comments').add(commentItem);

    var commentItemAdded = {
      'id' : docRef.id,
      'comment_content': commentContent,
      'date_comment': DateTime.now(),
      'number_of_likes': 0,
      'user': user,
      'video_id': videoID
    };

      completer.complete(commentItemAdded);

      DocumentSnapshot videoSnapshot = await FirebaseFirestore.instance.collection('Videos').doc(videoID).get();
      //
      dynamic videoData = videoSnapshot.data() as Map<String, dynamic>;
      if (userLogin?.userID != videoData['user']['user_id']) {
        Map<String, dynamic> notification = {
          'content': 'Đã bình luận video của bạn: "${commentContent}"',
          'date_notification': DateTime.now(),
          'status': false,
          'type': 1,
          'user_id': videoData['user']['user_id'],
          'user': user,
          'video_id': videoID
        };
        //
        await FirebaseFirestore.instance.collection('Notifications').add(notification)
            .catchError((error) {
          completer.completeError(error);
        }).catchError((error){
          completer.completeError(error);
        });
      }
    return completer.future;
  }

  Future<int> getCommentCountByVideoID(String videoID) async {
    try {
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('Comments')
          .where('video_id', isEqualTo: videoID)
          .get();
      return commentSnapshot.size;
    } catch (error) {
      print('Error getting comment count: $error');
      return 0; // Trả về 0 nếu có lỗi xảy ra
    }
  }

}
