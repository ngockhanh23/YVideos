import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:y_videos/screens/content_review/VideoPlayerReview.dart';
import 'package:y_videos/servieces/video_sevices.dart';

class ContentReview extends StatefulWidget {
  final String videoPath;

  ContentReview({required this.videoPath});

  @override
  State<ContentReview> createState() => _ContentReviewState();
}

class _ContentReviewState extends State<ContentReview> {
  late VideoPlayerController _controller;
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
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
                    borderRadius: BorderRadius.circular(10)
                ),
                child: VideoPlayerReview(
                  videoPath: widget.videoPath,
                )),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Tạo nội dung để cung cấp nhiều thông tin hơn",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  ),

                  border: InputBorder.none
                ),
              ),
            ),
            const Divider(thickness: 0.5,),

            ListTile(
              onTap: (){},
              leading: const Icon(Icons.remove_red_eye_outlined),
              title: Text("Đối tượng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Mọi người", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
            ListTile(
              onTap: (){},
              leading: const Icon(Icons.tag_sharp),
              title: Text("Hashtag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: const  Icon(Icons.arrow_forward_ios_rounded),
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
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: const  Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                )),
            const SizedBox(width: 10,),
            Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () {
                    VideoServices().uploadVideoContent(widget.videoPath).then((_) => {
                    showSnackBar(context),
                    Navigator.pop(context)

                    });
                  },
                  child: const Row(
                    children: [
                      const Spacer(),
                      const Icon(Icons.upload_outlined, color: Colors.white,),
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
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Đã đăng tải video của bạn'),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      // action: SnackBarAction(
      //   label: Text('đóng'),
      //
      //   onPressed: () {
      //     // Some action to take when user presses the action button
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
