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

  Future<void> setStatusNotification(String idNotification) async {
    await FirebaseFirestore.instance.collection('Notifications').doc(idNotification).update({
      'status' : true
    });
  }
}