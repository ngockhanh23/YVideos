import 'package:flutter/material.dart';

class EditIDProfile extends StatefulWidget{
  @override
  State<EditIDProfile> createState() => _EditIDProfileState();
}

class _EditIDProfileState extends State<EditIDProfile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _idController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          title: Text("YVideo ID"),
          centerTitle: true,
          actions: [TextButton(onPressed: () {}, child: Text("Lưu"))],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(4.0), // Độ dày của đường gạch dưới
              child: Container(
                color: Colors.black26, // Màu của đường gạch dưới
                height: 0.2,
              ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("YVideo ID", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
            Stack(
              children: [
                TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),)
                ),
                Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _idController.text= "";
                      },
                      icon: Icon(Icons.cancel, color: Colors.black45,),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}