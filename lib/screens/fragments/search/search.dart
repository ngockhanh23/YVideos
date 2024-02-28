import 'package:flutter/material.dart';

class SearchFragment extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Tìm kiếm"),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: TextField(
                // controller: _emailController,
                onSubmitted: (String searchTerm) {
                  // Xử lý hành động tìm kiếm ở đây
                  print('Tìm kiếm: ');
                },
                decoration: InputDecoration(
                  labelText: "Nhập nội dung tìm kiếm",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide
                        .none, // Set borderSide to none to remove the visible border
                  ),
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFEEEEEEFF),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tìm kiếm gần đây"),

                InkWell(
                  onTap: () => _showConfirmationDialog(context),
                  child: Text("Xóa lịch sử", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),),
                )
              ],
            ),



            Divider(thickness: 0.9,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/search-results');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.history
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '"Ngọc Khánh"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle( fontSize: 18),
                    )
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
  _showConfirmationDialog(BuildContext context)  {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Đặt màu nền thành trắng
          title: Text(
            'Xóa lịch sử tìm kiếm ?',
            style: TextStyle(
              color: Colors.black, // Đặt màu chữ thành đen
            ),
          ),
          content: Text(
            'Toàn bộ lịch sử tìm kiếm của bạn sẽ bị xóa và không thể khôi phục được',
            style: TextStyle(
              color: Colors.black, // Đặt màu chữ thành đen
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle 'Yes' button tap
                Navigator.of(context).pop(true);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Handle 'No' button tap
                Navigator.of(context).pop(false);
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}


