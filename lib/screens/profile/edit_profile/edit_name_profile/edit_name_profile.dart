import 'package:flutter/material.dart';

class EditNameProfile extends StatefulWidget {
  @override
  State<EditNameProfile> createState() => _EditNameProfileState();
}

class _EditNameProfileState extends State<EditNameProfile> {
  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text("Tên"),
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
                Text("Tên", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                Stack(
                  children: [
                    TextField(
                      controller: _nameController,
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
                            this._nameController.text= "";
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
