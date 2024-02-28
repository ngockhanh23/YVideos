
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/components/video_item/comments/comment_item.dart';
import 'package:y_videos/models/comment.dart';
import 'package:y_videos/servieces/comment_services.dart';

import '../../../models/account.dart';
import '../../../servieces/account_services.dart';

class CommentsList extends StatefulWidget {

  String videoID;
  String userID;
  CommentsList({super.key, required this.videoID,required this.userID});

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {

  List<Comment> _lstComments = [];
  bool iscommentsLoaded = true;

  // Map<String, dynamic> user = {};
  // String avatarUrl = "";
  Account? userLogin ;

  TextEditingController commentContent = TextEditingController();


  @override
  void initState() {
    getUserLogin();
    fetchCommentData();
    super.initState();
  }

  getUserLogin()  async {
    userLogin = await AccountServices.getUserLogin();
    // user = {
    //   'user_id': userLogin.userID,
    //   'avatar_url': AccountServices.getUserLogin().name,
    //   'user_name': AccountServices.getUserLogin().avatarUrl,
    // };
  }

  createComment(BuildContext context) {
    CommentServices().createComment(widget.videoID, commentContent.text).then((comment) {
      print('comment'+ comment.toString());
      setState(() {
        _lstComments.insert(
            0,
            Comment(
              comment['id'],
              comment['comment_content'],
              comment['number_of_likes'],
              comment['date_comment'],
              comment['user'],
              comment['video_id'],
            ));
      });
      FocusManager.instance.primaryFocus?.unfocus();
          commentContent.text = "";
    });

  }

  fetchCommentData() async {
    List<Map<String, dynamic>> listComments = await CommentServices().getCommentsByVideoID(widget.videoID);
    // print('list comment : ');
    // print(fetchedComments.toString());
    listComments.forEach((commentItem) {
      Comment comment = Comment(
        commentItem['id'],
        commentItem['comment_content'],
        commentItem['number_of_likes'],
        commentItem['date_comment'].toDate(),
        commentItem['user'],
        commentItem['video_id'],
      );
      _lstComments.add(comment);
    });
    setState(() {
        iscommentsLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [

          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 100),
            width: double.infinity,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: iscommentsLoaded ? const Center(child: CircularProgressIndicator()) :
              _lstComments.isEmpty?
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_comment_outlined, size: 70,color: Colors.grey,),
                    Text('Chưa có bình luận nào', style: TextStyle(fontSize: 20,),),
                    Text('Hãy là người bình luận đầu tiên', style: TextStyle(fontSize: 15,),),

                  ],
                ),
              )
                :SingleChildScrollView(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _lstComments.length.toString()+' Bình luận',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: _lstComments.map((commmentItem) => CommentItem(commentItem: commmentItem)).toList(),
                  )
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: userLogin == null
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                userLogin!.avatarUrl,
                              ),
                            )),
                  Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.white,

                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          color: Colors.white,
                          height: 50,
                          child: TextField(
                            controller: commentContent,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,

                              labelText: "Viết bình luận ...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFEEEEEEFF),
                              suffixIcon: IconButton(
                                onPressed: () => createComment(context),
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

      ],
    );
  }
}

