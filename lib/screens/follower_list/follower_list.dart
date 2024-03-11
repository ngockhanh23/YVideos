import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/screens/follower_list/follower_list_item.dart';
import 'package:y_videos/servieces/account_services.dart';

class FollowerList extends StatefulWidget {
  String userID;
  FollowerList({super.key, required this.userID});
  @override
  State<FollowerList> createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  List<Account> _lstAccount = [];

  _fetchFollowerList() async {

    AccountServices().getFollowerListByUserID(widget.userID).then((result) {
      setState(() {
        _lstAccount = result;
        print('list follower : ');
        print(_lstAccount);
      });
    });
  }

  @override
  void initState() {
    _fetchFollowerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Người theo dõi'),
        centerTitle: true,
      ),
      body: _lstAccount.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _lstAccount.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: FollowerListItem(
                    account: _lstAccount[index],
                  ),
                  onTap: () {
                    // Xử lý khi nhấn vào phần tử
                  },
                );
              },
            ),
    );
  }
}
