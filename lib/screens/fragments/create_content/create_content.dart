import 'package:flutter/material.dart';
import 'package:y_videos/screens/video_record/video_recoder.dart';
import 'package:file_picker/file_picker.dart';
import '../../content_review/content_review.dart';


class CreateContent extends StatelessWidget {

  Future<void> _pickVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ContentReview(
                videoPath: result.files.single.path!,
              )));
    } else {
      // User canceled the picker
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo nội dung"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoRecorder()));
              },
              child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.redAccent,
                      ],
                      stops: [0, 10.0],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          )
                        ],
                      ),
                      Text(
                        "Quay một video mới",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoUpload()));
                _pickVideo(context);
              },
              child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.green,
                      ],
                      stops: [0, 10.0],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Upload",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          )
                        ],
                      ),
                      Text(
                        "Upload video từ thiết bị của bạn",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
