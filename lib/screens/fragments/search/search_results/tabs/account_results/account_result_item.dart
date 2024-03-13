import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:y_videos/components/follow_button/follow_button.dart';
import 'package:y_videos/models/account.dart';

class AccountResultItem extends StatefulWidget {
  Account account;
  String userLoginID;

  AccountResultItem(
      {super.key, required this.account, required this.userLoginID});

  @override
  State<AccountResultItem> createState() => _AccountResultItemState();
}

class _AccountResultItemState extends State<AccountResultItem> {
  bool _isFollowed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      widget.account.avatarUrl,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.account.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.account.userID,
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        // Text(
                        //   "150 follower   20 video",
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       color: Colors.black54
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
            widget.account.userID == widget.userLoginID
                ? Container()
                : Expanded(
                    flex: 1,
                    child: FollowButton(
                        userID: widget.account.userID,
                        userLoginID: widget.userLoginID))
          ],
        ),
      ),
    );
  }
}
