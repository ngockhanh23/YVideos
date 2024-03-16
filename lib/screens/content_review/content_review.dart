import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:y_videos/components/dialog_helper/dialog_helper.dart';
import 'package:y_videos/screens/content_review/VideoPlayerReview.dart';
import 'package:y_videos/servieces/account_services.dart';
import 'package:y_videos/servieces/notification_services.dart';
import 'package:y_videos/servieces/video_sevices.dart';

import '../../models/video.dart';

class ContentReview extends StatefulWidget {
  final String videoPath;

  ContentReview({required this.videoPath});

  @override
  State<ContentReview> createState() => _ContentReviewState();
}

class _ContentReviewState extends State<ContentReview> {
  late VideoPlayerController _controller;
  final TextEditingController _contentController = TextEditingController();

  // bool _isUploading = false;
  int _privacyViewer = 0;
  String _privacyString = "Mọi người";

  // bool _videoUploaded = false;
  Video? _videoUploaded;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  _handleUploadVideo() {
    // print('hahaha');

    _showUploadingDialog();
    VideoServices()
        .uploadVideoContent(
            widget.videoPath, _contentController.text, _privacyViewer)
        .then((video) => {
              _videoUploaded = video,
              Navigator.pop(context),
              DialogHelper.successToastSnackbar(
                  context, 'Video của bạn đã được đăng tải', 3),
              // if (_videoUploaded != null)
              //   {
              //     _addNotificaitonFollowUser(),
              //   },
              Navigator.pop(context)
            });
  }

  _addNotificaitonFollowUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userLoginID = prefs.getString('user_id') ?? "";

    AccountServices()
        .getFollowerListByUserID(userLoginID)
        .then((lstFollower) async {
      await Future.forEach(lstFollower, (account) async {
        // Gọi hàm addNotification với từ khóa await
        await NotificationServices().addNotification(account.userID,
            userLoginID, 'Đã đăng tải một video', 1, _videoUploaded!.id);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoUploaded != null && _privacyViewer == 0) {
      _addNotificaitonFollowUser();
    }
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: VideoPlayerReview(
                  videoPath: widget.videoPath,
                )),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText:
                        "Tạo nội dung để cung cấp nhiều thông tin hơn",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
            const Divider(
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () => _showPrivacyOption(),
                leading: Icon(Icons.remove_red_eye_outlined),
                title: Text("Đối tượng",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _privacyString,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.tag_sharp),
              title: const Text("Hashtag",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        // shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () => _handleUploadVideo(),
                  child: Row(
                    children: [
                      const Spacer(),
                      const Icon(
                        Icons.upload_outlined,
                        color: Colors.white,
                      ),
                      const Text(
                        "Đăng",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _showPrivacyOption() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Chọn quyền riêng tư:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  InkWell(
                    onTap: () {
                      _privacyViewer = 0;
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 5,
                          child: ListTile(
                            title: Text("Công khai"),
                            leading: Icon(Icons.public),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Radio(
                            value: 0,
                            groupValue: _privacyViewer,
                            onChanged: (value) {
                              _privacyViewer = value!;
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _privacyViewer = 1;

                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 5,
                          child: ListTile(
                            title: Text("Riêng tư"),
                            leading: Icon(Icons.lock_outline),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Radio(
                            value: 1,
                            groupValue: _privacyViewer,
                            onChanged: (value) {
                              _privacyViewer = value!;
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        switch (_privacyViewer) {
          case 0:
            _privacyString = "Mọi người";
            break;
          case 1:
            _privacyString = "Riêng tư";
            break;
          default:
            _privacyString = "Mọi người";
            break;
        }
      });
    });
  }

  void _showUploadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // Màu nền của hộp thoại
          shape: RoundedRectangleBorder(
            // Tạo hình dạng cho hộp thoại
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20.0),
          // Định dạng kích thước của nội dung
          content: const SizedBox(
            height: 150, // Chiều cao của nội dung
            width: 300, // Chiều rộng của nội dung
            // color: Colors.blue, // Màu nền của nội dung
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                const Text("Đang tải lên video của bạn...",
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        );
      },
    );
  }
}
