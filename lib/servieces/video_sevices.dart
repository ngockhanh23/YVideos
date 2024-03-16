import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:y_videos/models/video_likes.dart';
import 'package:y_videos/servieces/account_services.dart';
import 'package:y_videos/servieces/notification_services.dart';

import '../models/account.dart';
import '../models/video.dart';

class VideoServices{

  Future<dynamic> getVideoByID(String videoID) async {
    try {
      DocumentSnapshot videoSnapshot = await FirebaseFirestore.instance
          .collection('Videos')
          .doc(videoID)
          .get();
      if (videoSnapshot.exists) {

          Video video = Video(
            videoSnapshot.id,
            videoSnapshot['video_url'],
            videoSnapshot['content_video'],
            videoSnapshot['date_upload'].toDate(),
            videoSnapshot['privacy_viewer'],
            videoSnapshot['user_id'],
          );

        return video;
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      return null;
    }
  }

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

  Future<dynamic> uploadVideoContent(String filePath, String content, int privacyViewer) async {
    Video video = Video.empty();

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
        }).then((DocumentReference docRef) async {
          // Lấy thông tin của tài liệu vừa được thêm
          DocumentSnapshot snapshot = await docRef.get();

          // In ra tất cả các thuộc tính của tài liệu
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // video = Video(docRef.id, data['video_url'], data['content_video'], data['date_upload'], data['privacy_viewer'], data['user_id']);
          video.id = docRef.id.toString();
          video.videoUrl = data['video_url'];
          video.contentVideo = data['content_video'];
          video.dateUpload = data['date_upload'].toDate();
          video.privacyViewer = data['privacy_viewer'];
          video.userID = data['user_id'];


          return video;

          print(video);
        });

      });
      return video;

    } catch (e) {
      // return Video('_id', '_videoUrl', '_contentVideo', DateTime.now(), 1, '_userID');
      return null;
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