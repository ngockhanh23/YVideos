import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:y_videos/models/video_likes.dart';
import 'package:y_videos/servieces/account_services.dart';

import '../models/account.dart';
import '../models/video.dart';

class VideoServices{



  Future<List<VideoLikesByUser>> getVideoLikesByVideoID(String videoID) async {
    try {
      // Query để lấy tất cả các lượt thích có video_id trùng khớp với videoID được truyền vào
      QuerySnapshot videoLikesSnapshot = await FirebaseFirestore.instance
          .collection('Video_Likes')
          .where('video_id', isEqualTo: videoID)
          .get();

      List<VideoLikesByUser> lstLikedVideo = [];

      for (var doc in videoLikesSnapshot.docs) {

        lstLikedVideo.add(VideoLikesByUser(
            doc.id,
            doc['video_id'],
            doc['user_id'])
        );
        return lstLikedVideo;
        //
        // videoList.add(video);
      }

      return [];
    } catch (error) {
      print('Lỗi khi lấy danh sách lượt thích: $error');

      return [];
    }
  }

  Future<VideoLikesByUser> likeVideo(String userID, String videoID) async {
    try {
      var docRef = await FirebaseFirestore.instance.collection('Video_Likes').add({
        'video_id': videoID,
        'user_id': userID,
      });

      // Trả về đối tượng VideoLikesByUser khi thêm thành công
      return VideoLikesByUser(docRef.id, videoID,userID);
    } catch (error) {
      // Xử lý khi có lỗi xảy ra
      print('Lỗi khi thích video: $error');
      throw error;
    }
  }



  Future<void> unLikeVideo(String likeID,) async {
    try {
      // Thêm thông tin like vào collection Video_Likes
      FirebaseFirestore.instance.collection('Video_Likes').doc(likeID).delete();
    } catch (error) {
      // Xử lý khi có lỗi xảy ra
      print('Lỗi khi thích video: $error');
      throw error;
    }
  }

  Future<void> uploadVideoContent(String filePath, String content, int privacyViewer) async {
    try {
      File videoFile = File(filePath);
      Account userLogin = await AccountServices.getUserLogin();

      Reference storageReference = FirebaseStorage.instance.ref().child('${userLogin.userID}/videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

      // Upload video lên Firebase Storage
      UploadTask uploadTask = storageReference.putFile(videoFile);

      // Lắng nghe sự kiện hoàn thành khi upload
      await uploadTask.whenComplete(() async {
        // Lấy đường dẫn đến video sau khi upload thành công
        String videoURL = await storageReference.getDownloadURL();

        CollectionReference videosCollection = FirebaseFirestore.instance.collection('Videos');
        // Thêm một tài liệu mới vào bộ sưu tập
        await videosCollection.add({
          'content_video': content,
          'date_upload': DateTime.now(),
          'privacy_viewer' : privacyViewer,
          'user_id': userLogin.userID,
          'video_url' : videoURL
          // Thêm các trường dữ liệu khác nếu cần thiết
        });

      });


    } catch (e) {
      print('Lỗi khi upload video: $e');
    }

  }

  Future<List<Video>> getVideosBySearchKey(String searchKey) async {
    try {

      QuerySnapshot contentVideoQuery  = await FirebaseFirestore.instance
          .collection('Videos')
          .where('content_video', isGreaterThanOrEqualTo: searchKey)
          .where('content_video', isLessThan: searchKey + 'z')
          .get();

      QuerySnapshot userIdQuery = await FirebaseFirestore.instance
          .collection('Videos')
          .where('user_id', isEqualTo: searchKey)
          .get();

      List<DocumentSnapshot> mergedResults = [];
      mergedResults.addAll(contentVideoQuery.docs);
      mergedResults.addAll(userIdQuery.docs);
      mergedResults.sort((a, b) => a['content_video'].compareTo(b['content_video']));

      List<Video> lstVideo =[];
      for (var doc in mergedResults) {
        Video video = Video(
            doc.id,
            doc['video_url'],
            doc['content_video'],
            doc['date_upload'].toDate(),
            doc['privacy_viewer'],
            doc['user_id']
        );
        lstVideo.add(video);
      }

      return lstVideo;

    } catch (e) {
      return [];
    }
  }
}