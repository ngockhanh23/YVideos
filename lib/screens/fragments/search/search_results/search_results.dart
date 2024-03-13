import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/account_results/account_results.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_results.dart';

class SearchResults extends StatelessWidget{

  String searchKey;
  SearchResults({super.key, required this.searchKey});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kết quả tìm kiếm"),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Video'),
                Tab(text: 'Người dùng'),
              ],
            )
        ),
        body: TabBarView(
          children: [
            VideoResults(searchKey: searchKey,),
            AccountResults(searchKey: searchKey,),
            // Thêm TabBarView khác nếu cần
          ],
        )
      ),
    );
  }
}