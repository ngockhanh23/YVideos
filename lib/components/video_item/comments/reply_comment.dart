import 'package:flutter/material.dart';

class ReplyComment extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
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
                      'https://scontent.fhan3-5.fna.fbcdn.net/v/t39.30808-6/398037473_122147783762008645_1751851070619928121_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeHC4fK1xnokRsdWFdwQ_zIyQLs86gf-ypdAuzzqB_7KlwdkjrvQk7J4DmhLXy8rLKrz1QzWTvOwqgjRh7H4PAWW&_nc_ohc=N9fOc-yT3XoAX9Jr5WG&_nc_ht=scontent.fhan3-5.fna&oh=00_AfB-zSQgZQ41MvUHKOWILWzrPn7ofNZx5s8QtaVH642Grw&oe=65AB0741',
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
                    Text("Ngọc Khánh",
                      maxLines: 80,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),),
                    SizedBox(height: 5),
                    Text("Đây là một bình luận để test thôi, không biết viết gì",
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
                        Text("17/01/2024", style: TextStyle(color: Colors.black54),),
                        SizedBox(width: 20),
                        InkWell(
                          child: Text("Trả lời", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                        )


                      ],
                    ),



                  ],
                ),
              )),
          Expanded(
              child: InkWell(
                child: Column(

                  children: [
                    InkWell(
                      onTap: (){},
                      child: Icon(Icons.favorite_outlined),
                    ),
                    Text("12")
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}