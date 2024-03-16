import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification.dart';

class NotificationServices {

  Future<List<NotificationUser>> fetchNotificationByUserID(String userID) async {
    try {
      QuerySnapshot notificationSnapshot = await FirebaseFirestore.instance.collection('Notifications')
          .where('user_id', isEqualTo: userID, )
          .get();
      List<NotificationUser> lstNotifications = [];
      notificationSnapshot.docs.forEach((doc) {
        // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        NotificationUser notificationUser = NotificationUser(
          doc.id,
          doc['user_id'],
          doc['user_notification'],
          doc['type'],
          doc['status'],
          doc['content'],
          doc['video_id'],
          doc['date_notification'].toDate(),
        );
        lstNotifications.add(notificationUser);
      });

        lstNotifications.sort((a, b) => a.dateNotification.compareTo(b.dateNotification));
        return lstNotifications;
    } catch (e) {
      print('error notification : $e');
      return [];
    }
  }

  Future<void> addNotification(String userID, String userNotification, String content, int type, String videoID) async {


    try {
      Map<String, dynamic> notification = {
        'content': content,
        'date_notification': DateTime.now(),
        'status': false,
        'type': type,
        'user_id': userID,
        'user_notification': userNotification,
        'video_id': videoID
      };

      // Thêm thông báo vào Firestore
      await FirebaseFirestore.instance.collection('Notifications').add(notification);

      print('Thông báo đã được thêm thành công.');
    } catch (error) {
      print('Lỗi khi thêm thông báo: $error');
    }
  }

  Future<void> setStatusNotification(String idNotification) async {
    await FirebaseFirestore.instance.collection('Notifications').doc(idNotification).update({
      'status' : true
    });
  }
}