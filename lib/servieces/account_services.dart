import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/models/account.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AccountServices {
  Future<Account> getAccountByUserID (String userID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('userID', isEqualTo: userID).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs[0].data() as Map<String, dynamic>;

        return Account(
          userData['userID'].toString(),
          userData['userName'].toString(),
          userData['avatarUrl'].toString(),
          userData['userEmail'].toString(),
          "",
        );

      // authService.account = account; // Nếu cần thiết
    } else {
      return Account.empty();
    }
  }
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove('avatar_url');
      await prefs.remove('id_user_doc');
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
      // Xử lý lỗi ở đây nếu cần
    }
  }
  Future<bool> checkCurrentUserPassword(String currentPassword) async {
    try {
      // Lấy thông tin người dùng hiện tại
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Xác thực lại người dùng để lấy mật khẩu hiện tại
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: currentPassword,
        );

        // Thực hiện xác thực lại
        await currentUser.reauthenticateWithCredential(credential);

        // Nếu không có lỗi xảy ra, nghĩa là mật khẩu hiện tại hợp lệ
        return true;
      } else {
        // Người dùng không đăng nhập
        print("Người dùng chưa đăng nhập");
        return false;
      }
    } catch (e) {
      print("Lỗi khi xác thực mật khẩu hiện tại: $e");
      // Xử lý lỗi ở đây nếu cần
      return false;
    }
  }

  Future<bool> checkIDExists(String idUser) async {
    try {
      // Thực hiện truy vấn trong Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userID', isEqualTo: idUser)
          .get();

      return querySnapshot.docs.isNotEmpty;

    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }
  Future<void> changePassword(String newPassword) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {

      throw e;
    }
  }


  Future<void> editIdUser(String newID) async {
    try {
      // Lấy userID từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIDdoc = prefs.getString('id_user_doc') ?? '';

      // Kiểm tra xem userID có tồn tại không
      if (userIDdoc.isNotEmpty) {
        // Thực hiện cập nhật tên người dùng trên Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userIDdoc).update({'userID': newID}).then((value) {
          print('Cập nhật id người dùng thành công.');
          prefs.setString('user_id', newID);
        });
      } else {
        print('Không thể tìm thấy userID.');
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi cập nhật id người dùng: $error');
    }
  }

  Future<void> editNameUser(String newName) async {
    try {
      // Lấy userID từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIDdoc = prefs.getString('id_user_doc') ?? '';

      // Kiểm tra xem userID có tồn tại không
      if (userIDdoc.isNotEmpty) {
        // Thực hiện cập nhật tên người dùng trên Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userIDdoc).update({'userName': newName}).then((value) {
          print('Cập nhật tên người dùng thành công.');
          prefs.setString('user_name', newName);
        });
      } else {
        print('Không thể tìm thấy userID.');
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi cập nhật tên người dùng: $error');
    }
  }

  Future<void> uploadImageToFirebase(String filePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String idUser = prefs.getString('user_id') ?? "";
      String idUserDoc = prefs.getString('id_user_doc') ?? "";
      File imageFile = File(filePath);
      Reference storageReference = FirebaseStorage.instance.ref().child('${idUser}/images/avatar/${DateTime.now().millisecondsSinceEpoch}.png');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async{
        String imageURL = await storageReference.getDownloadURL();
        // print(imageURL);
        await FirebaseFirestore.instance.collection('Users').doc(idUserDoc).update({'avatarUrl': imageURL}).then((_) {
          prefs.setString('avatar_url', imageURL);
        });
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String> checkFollowExists(String followerId, String userId) async {
    try {
      // Thực hiện truy vấn trong Firestore để kiểm tra sự tồn tại của một cặp (follower_id, user_id)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Follows')
          .where('follower_id', isEqualTo: followerId)
          .where('user_id', isEqualTo: userId)
          .get();

      // Nếu có ít nhất một tài liệu trong kết quả trả về, đồng nghĩa với việc cặp (follower_id, user_id) tồn tại
      if (querySnapshot.docs.isNotEmpty) {
        // Trả về ID của tài liệu đầu tiên trong kết quả trả về
        return querySnapshot.docs.first.id;
      } else {
        // Trả về chuỗi rỗng nếu không tìm thấy cặp (follower_id, user_id)
        return '';
      }
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi xảy ra
      print('Error checking follow: $e');
      return '';
    }
  }


  Future<String> createFollow(String followerID, String userID) async {
    Completer<String> completer = Completer<String>();

    try {
      CollectionReference follows = FirebaseFirestore.instance.collection('Follows');

      Map<String, dynamic> follow = {
        'follower_id': followerID,
        'user_id': userID,
        'notification_id': ""
      };

      DocumentReference followDocRef = await follows.add(follow);
      String followID = followDocRef.id;

      CollectionReference notifications = FirebaseFirestore.instance.collection('Notifications');
      Account userLogin = await AccountServices.getUserLogin();

      Map<String, dynamic> notification = {
        'content': "Đã bắt đầu theo dõi bạn",
        'date_notification': DateTime.now(),
        'status': false,
        'type': 2,
        'user_id': userID,
        'user_notification': userLogin.userID,
        'video_id': ""
      };

      DocumentReference notificationDocRef = await notifications.add(notification);
      String notificationID = notificationDocRef.id;

      await follows.doc(followID).update({'notification_id': notificationID});

      completer.complete(followID);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }




  Future<void> deleteFollow(String followID) async {
    String notificationFollowID = "";
    DocumentReference followRef = FirebaseFirestore.instance.collection('Follows').doc(followID);
    DocumentSnapshot followSnapshot = await followRef.get();

    if (followSnapshot.exists) {
      Map<String, dynamic> followData = followSnapshot.data() as Map<String, dynamic>;
      notificationFollowID = followData['notification_id'];

      // Xóa tài liệu Follow
      await followRef.delete();
      if (notificationFollowID.isNotEmpty) {
        DocumentReference followNotiRef = FirebaseFirestore.instance.collection('Notifications').doc(notificationFollowID);
        DocumentSnapshot followNotiSnapshot = await followNotiRef.get();

        if (followNotiSnapshot.exists) {
          await followNotiRef.delete();
        }
      }
    }
  }

  Future<List<Account>> getFollowerListByUserID(String UserID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Follows')
          .where('user_id', isEqualTo: UserID)
          .get();
      List<Account> lstAccount = [];

      // Sử dụng Future.forEach để chờ tất cả các lời hứa được giải quyết
      await Future.forEach(querySnapshot.docs, (doc) async {
        Account account = await getAccountByUserID(doc['follower_id']);
        lstAccount.add(account);
      });

      return lstAccount;
    } catch (e) {
      print('Lỗi khi lấy danh sách follower: $e');
      return []; // Trả về một danh sách trống trong trường hợp xảy ra lỗi
    }
  }

  Future<List<Account>> getListUsersBySearchKey(String searchKey)async{
    try {

      QuerySnapshot userNameQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isGreaterThanOrEqualTo: searchKey)
          .where('userName', isLessThan: searchKey + 'z')
          .get();

      QuerySnapshot userIdQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('userID', isEqualTo: searchKey)
          .get();

      List<DocumentSnapshot> mergedResults = [];
      mergedResults.addAll(userNameQuery.docs);
      // mergedResults.addAll(userName2Query.docs);
      mergedResults.addAll(userIdQuery.docs);
      // mergedResults.sort((a, b) => a['content_video'].compareTo(b['content_video']));

      List<Account> lstAccount =[];
      for (var doc in mergedResults) {
        Account account = Account(
            doc['userID'],
            doc['userName'],
            doc['avatarUrl'],
            doc['email'],
            '');
        lstAccount.add(account);
      }
      // Account account = new Account('_userID', '_userName', '_avatarUrl', '_email', '_password');
      // lstAccount.add(account);
      return lstAccount;

    } catch (e) {
      return [];
    }
  }

  static getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Account(
        prefs.getString('user_id') ?? "",
        prefs.getString('user_name') ?? "",
        prefs.getString('avatar_url') ?? "", "", "");
  }
}
