import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/account_results/account_result_item.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_result_item.dart';
import 'package:y_videos/servieces/account_services.dart';

import '../../../../../../models/account.dart';

class AccountResults extends StatefulWidget {
  String searchKey;

  AccountResults({super.key, required this.searchKey});

  @override
  State<AccountResults> createState() => _AccountResultsState();
}

class _AccountResultsState extends State<AccountResults> {
  List<Account> _lstAccount = [];

  String? _userLoginID;

  _getUserLoginID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userLoginID = prefs.getString('user_id') ?? "";
  }

  getListAccount() {
    AccountServices().getListUsersBySearchKey(widget.searchKey).then((result) {
      setState(() {
        _lstAccount = result;
      });
    });
  }

  @override
  void initState() {
    getListAccount();
    _getUserLoginID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _lstAccount.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: _lstAccount.length, // Số lượng item trong ListView
            itemBuilder: (BuildContext context, int index) {
              return _userLoginID != null
                  ? AccountResultItem(
                      account: _lstAccount[index],
                      userLoginID: _userLoginID!,
                    )
                  : Container();
            },
          );
  }
}
