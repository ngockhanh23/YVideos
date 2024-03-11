import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/components/thumbnail_video/thumbnail_video.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/models/notification.dart';
import 'package:y_videos/screens/follower_list/follower_list.dart';
import 'package:y_videos/servieces/account_services.dart';
import 'package:y_videos/servieces/date_time_vn_format.dart';
import 'package:y_videos/servieces/notification_services.dart';
import 'package:y_videos/servieces/video_sevices.dart';

import '../../../models/video.dart';
import '../../video_item_screen/video_item_screen.dart';

class NotificationItem extends StatefulWidget {
  NotificationUser notificationUser;

  NotificationItem({super.key, required this.notificationUser});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  Video? _video;
  Account? _userNotification;

  @override
  void initState() {
    // getVideo();
    if (widget.notificationUser.type == 1) {
      _getVideo();
    }
    _getUser();

    super.initState();
  }

  _getVideo() async {
    if (widget.notificationUser.type == 1) {
      VideoServices().getVideoByID(widget.notificationUser.videoID).then((result) {
        setState(() {
          _video = result;
        });
      });
      // VideoServices().get
    }
  }

  _getUser() async {
    AccountServices()
        .getAccountByUserID(widget.notificationUser.userNotification)
        .then((account) {
      setState(() {
        _userNotification = account;
      });
    });
  }

  _handleClickNotification(){
    if(widget.notificationUser.status == false){
      NotificationServices().setStatusNotification(widget.notificationUser.id).then((_) {
        setState(() {
          widget.notificationUser.status = true;
        });
      });
    }
    if (widget.notificationUser.type == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoItemScreen(video: _video!),
          ));
    } else if(widget.notificationUser.type == 2){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FollowerList()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
          onTap: () => _handleClickNotification(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: widget.notificationUser.status == false ? Color(0x000).withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              // color: Service.primaryColor,
                              // borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black38),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  _userNotification == null
                                      ? ""
                                      : _userNotification!.avatarUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: -1,
                              right: -2,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: widget.notificationUser.type == 1
                                      ? Colors.blue
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                      style: BorderStyle.solid),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 35,
                                  minHeight: 35,
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.notificationUser.type == 1
                                        ? Icons.mode_comment
                                        : widget.notificationUser.type == 2
                                            ? Icons.favorite
                                            : Icons.star,
                                    // hoặc biểu tượng khác tuỳ thuộc vào trường hợp của bạn
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userNotification == null
                                  ? ""
                                  : _userNotification!.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.notificationUser.content,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateTimeVNFormat.formatDate(
                                  widget.notificationUser.dateNotification),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.notificationUser.type == 1 && _video != null)
                  Flexible(
                    flex: 1,
                    child: Container(
                        height: 100,
                        width: 65,
                        child: ThumbnailVideo(video: _video!)),
                  )
              ],
            ),
          )),
    );
  }
}
