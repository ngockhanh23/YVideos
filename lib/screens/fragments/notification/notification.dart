import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/screens/fragments/notification/notification_item.dart';
import 'package:y_videos/models/notification.dart';
import 'package:y_videos/servieces/notification_services.dart';

class NotificationFragment extends StatefulWidget {
  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  List<NotificationUser> lstNotifications = [];
  bool isLstNotiLoading = true;

  @override
  void initState() {
    fetchNotificationData();
    super.initState();
  }


  fetchNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('user_id') ?? "";
    NotificationServices().fetchNotificationByUserID(userID).then((result) {
      setState(() {
        lstNotifications = result;
        isLstNotiLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tất cả thông báo"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showModalBottomSheet(context),
            icon: Icon(Icons.filter_list_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Làm mới thông báo')),
            // NotificationItem()
            const Divider(),
            if(isLstNotiLoading)
              const CircularProgressIndicator()
            else
            if(lstNotifications.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 50,color: Colors.grey,),
                    Text('Bạn không có thông báo nào', style: TextStyle(fontSize: 20),)
                  ],
                ),
              )
            else
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: lstNotifications.reversed.map((notification) => NotificationItem(notificationUser: notification)).toList(),
              )

          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_none_sharp,
                                color: Colors.black87,
                              ),
                              Text(
                                "Tất cả thông báo",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                const Divider(
                  thickness: 1,
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
                            children: [
                              Icon(
                                Icons.favorite_outline_sharp,
                                color: Colors.black87,
                              ),
                              Text(
                                "Lượt thích và đăng ký",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                const Divider(
                  thickness: 1,
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
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                "Bình luận",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
              ],
            ));
      },
    );
  }
}
