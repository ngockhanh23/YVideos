import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/search_results.dart';

class SearchFragment extends StatelessWidget{

  TextEditingController _searchKeyController = TextEditingController();
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

              child: TextField(
                controller: _searchKeyController,
                onSubmitted: (String searchTerm) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResults(searchKey: _searchKeyController.text.trim())));

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResults(searchKey: _searchKeyController.text)));
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


