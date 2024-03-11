import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/screens/profile/profile.dart';

import '../../models/account.dart';
import '../profile/personal_profile/personal_profile.dart';

class FollowerListItem extends StatelessWidget {

  Account account;
  FollowerListItem({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PersonalProfile(userID: account.userID) ));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      account.avatarUrl,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          account.userID,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),


              InkWell(
                onTap: () {
                },
                child: Container(
                  width: 110,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text(
                        "Xóa",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
