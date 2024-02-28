import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:y_videos/models/video_likes.dart';

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

  Future<void> uploadVideoContent(String filePath) async {
    try {
      File videoFile = File(filePath);
      Reference storageReference = FirebaseStorage.instance.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
      UploadTask uploadTask = storageReference.putFile(videoFile);
      uploadTask.then((_) {
        print('Upload video thành công!');
      });
      await uploadTask;
    } catch (e) {
      print('Lỗi khi upload video: $e');
    }
  }
}