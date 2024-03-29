import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:y_videos/components/thumbnail_video/thumbnail_video.dart';
import 'package:y_videos/models/video.dart';

import '../../../../../../models/account.dart';
import '../../../../../../servieces/account_services.dart';

class VideoResultItem extends StatelessWidget{

  Video video;
  VideoResultItem({super.key, required this.video});




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: InkWell(
        child: Column(

          children: [
            Container(
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ThumbnailVideo(
                video: video,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(video.contentVideo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                  ),
                ),

                UserUpload(userID: video.userID,),
              ],
            )


          ],
        ),
      ),
    );
  }
}

class UserUpload extends StatefulWidget{
  String userID;
  UserUpload({super.key, required this.userID});
  @override
  State<UserUpload> createState() => _UserUploadState();
}

class _UserUploadState extends State<UserUpload> {

  Account? _userUpload;



  _getUserUpload() {
    AccountServices().getAccountByUserID(widget.userID).then((value){
      setState(() {
        _userUpload = value;
      });
    });
  }

  @override
  void initState() {
    _getUserUpload();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _userUpload == null
        ? Container()
        : Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
            _userUpload!.avatarUrl,
          ),
        ),
        SizedBox(width: 8), // Đặt khoảng cách giữa CircleAvatar và Text
        Flexible(
          child: Text(
            _userUpload!.userID,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}


