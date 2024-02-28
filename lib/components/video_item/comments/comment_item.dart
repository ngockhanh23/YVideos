import 'package:flutter/material.dart';
import 'package:y_videos/servieces/date_time_vn_format.dart';
import '../../../models/comment.dart';

class CommentItem extends StatefulWidget{
  Comment commentItem;
  CommentItem({super.key,required this.commentItem});
  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  bool isLikedComment = false;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {},
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  // color: Service.primaryColor,
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 2, color: Colors.black12),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.commentItem.user['avatar_url'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.commentItem.user['user_name'],
                      maxLines: 80,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),),
                    SizedBox(height: 5),
                    Text(widget.commentItem.commentContent,
                      maxLines: 80,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                      ),),

                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(DateTimeVNFormat.formatDate(widget.commentItem.dateComment), style: TextStyle(color: Colors.black54),),
                        SizedBox(width: 20),
                        InkWell(
                          child: Text("Trả lời", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                        )


                      ],
                    ),


                    Container(
                      child: Column(
                        children: [
                          // ReplyComment(),
                          // ReplyComment(),
                        ],
                      ),
                    ),

                    // InkWell(
                    //   child: Row(
                    //     children: [
                    //       Text("Xem phản hồi (4)",
                    //
                    //         style: TextStyle(
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.black45
                    //         ),),
                    //       Icon(Icons.arrow_drop_down_sharp, color: Colors.black45,)
                    //     ],
                    //   ),
                    // )

                  ],
                ),
              )),
          Expanded(
              child: Center(
                child: Column(

                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          // widget.commentItem.numberOfLikes ++;
                          // !this.isLikedComment ? this.isLikedComment = true : this.isLikedComment = false;
                          if(!isLikedComment){
                            isLikedComment = true;
                            widget.commentItem.numberOfLikes ++;
                          }
                          else{
                            isLikedComment = false;
                            widget.commentItem.numberOfLikes --;
                          }
                        });
                      },
                      child: Icon(Icons.favorite_outlined,color: !this.isLikedComment ? Colors.black26 : Colors.redAccent,),
                    ),
                    Text(widget.commentItem.numberOfLikes.toString())
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}