import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tài khoản"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                onTap: () => _changeImagesModalBottomSheet(context),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        'https://pbs.twimg.com/media/EYVxlOSXsAExOpX.jpg',
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt_outlined, color: Colors.white,size: 50,),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("Giới thiệu về bạn", style: TextStyle(color: Colors.black45, fontSize: 15),),
            ),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/edit-name-profile");

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tên", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Text("Ngọc Khánh", style: TextStyle(fontSize: 18,color: Colors.black54),),
                        Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 20,)
                      ],
                    ),

                  ],
                ),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/edit-id-profile");

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("YVideo ID", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Text("ngc_knh", style: TextStyle(fontSize: 18,color: Colors.black54),),
                        Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 20,)
                      ],
                    ),

                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Mật khẩu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Text("**********", style: TextStyle(fontSize: 18,color: Colors.black54),),
                        Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 20,)
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeImagesModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                "Chọn ảnh từ thư viện",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                Divider(
                  thickness: 0.3,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.black87,
                              ),
                              Text(
                                "Chụp ảnh",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          )),
                    )),
                Divider(
                  thickness: 0.3,
                ),

                Expanded(
                    flex: 1,
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Hủy",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }
}