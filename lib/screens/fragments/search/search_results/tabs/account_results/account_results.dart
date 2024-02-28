import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/account_results/account_result_item.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_result_item.dart';

class AccountResults extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemCount: 1, // Số lượng item trong ListView
      itemBuilder: (BuildContext context, int index) {
        return AccountResultItem();
      },
    )
    ;
  }
}