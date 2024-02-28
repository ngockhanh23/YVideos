import 'package:flutter/material.dart';

class AccountResultItem extends StatefulWidget{
  @override
  State<AccountResultItem> createState() => _AccountResultItemState();
}

class _AccountResultItemState extends State<AccountResultItem> {
  bool _isFollowed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){},
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
                    'https://www.meme-arsenal.com/memes/4408af6c9803cb3f320ecc468b3abbfa.jpg',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ngọc Khánh",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "ngc_knh",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54
                        ),
                      ),
                      Text(
                        "150 follower   20 video",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            !this._isFollowed ? InkWell(
              onTap: () {
                setState(() {
                  this._isFollowed = true;
                });
              },
              child: Container(
                width: 110,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Text(
                      "Follow",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ):
              InkWell(
                onTap: () {
                  setState(() {
                    this._isFollowed = false;
                  });
                },
                child: Container(
                  width: 110,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: Text(
                    "Đang Follow",
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