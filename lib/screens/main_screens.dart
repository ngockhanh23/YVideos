import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/account/account.dart';
import 'package:y_videos/screens/fragments/create_content/create_content.dart';
import 'package:y_videos/screens/fragments/home/home.dart';
import 'package:y_videos/screens/fragments/notification/notification.dart';
import 'package:y_videos/screens/fragments/search/search.dart';
import 'package:y_videos/screens/login/login.dart';
import 'package:y_videos/screens/video_record/video_recoder.dart';



class MainScreens extends StatefulWidget {
  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _indexFragment = 0;


  List<Widget> lstScreen = [
    HomeFragment(),
    SearchFragment(),
    CreateContent(),
    NotificationFragment(),
    AccountFragment()
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // body: IndexedStack(
      //   index: _indexFragment,
      //   children: lstScreen,
      // ),
      body: lstScreen[_indexFragment],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white, width: 1), // Gạch trắng ngang
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _indexFragment,
          onTap: (index) {
            setState(() {
                _indexFragment = index;
            });
          },
          backgroundColor:
          _indexFragment == 0 ? Colors.black : null, // Đặt màu nền chỉ khi _indexFragment = 0
          unselectedItemColor:
          _indexFragment == 0 ? Colors.white : null, // Đặt màu chữ và icon khi chưa được chọn là trắng
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Trang chủ",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: "Tìm kiếm"),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: _indexFragment == 0
                      ? Colors.white
                      : Colors.black, // Màu nền là trắng
                  borderRadius: BorderRadius.circular(10), // Bo góc
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: _indexFragment == 0
                      ? Colors.black
                      : Colors.white,
                ), // Icon màu đen
              ),
              label: "",
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: "Hộp thư"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: "Tôi"),
          ],
        ),
      )
    );
  }
}
