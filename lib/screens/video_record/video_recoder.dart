import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import '../content_review/content_review.dart';

class VideoRecorder extends StatefulWidget {
  @override
  State<VideoRecorder> createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  bool isRecording = false;
  int _cameraIndex = 0;
  Duration _recordedTime = Duration(seconds: 0);

  @override
  void initState() {
    getCamera();
    super.initState();
  }

  getCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("Không có camera nào trên thiết bị của bạn.");
      } else {
        _cameraController = CameraController(cameras[_cameraIndex], ResolutionPreset.high);
        _cameraController?.initialize().then((value) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    } catch (e) {
      print("Lỗi khi truy cập danh sách camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _onRecordButtonPressed() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() async {
    try {
      await _cameraController!.startVideoRecording();
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          _recordedTime = Duration(seconds: _recordedTime.inSeconds + 1);
        });
      });
      setState(() {
        isRecording = true;
        _recordedTime = Duration(seconds: 0);
      });
    } catch (e) {
      print("Lỗi khi bắt đầu quay video: $e");
    }
  }

  void _stopRecording() async {
    if (!_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        isRecording = false;
      });

      // Điều hướng đến màn hình phát video
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ContentReview(videoPath: videoFile.path),
        ),
      );
    } catch (e) {
      print("Lỗi khi dừng quay video: $e");
    }
  }
  void _toggleCamera() async {
    // Tính chỉ số của camera tiếp theo
    // _cameraIndex = (_cameraIndex + 1) % cameras.length;
    if(_cameraIndex == 0)
      _cameraIndex = 1;
    else
      _cameraIndex = 0;

    // Dispose camera hiện tại
    await _cameraController?.dispose();

    // Khởi tạo camera mới
    _cameraController = CameraController(cameras[_cameraIndex], ResolutionPreset.high);

    // Khởi tạo lại camera
    await _cameraController?.initialize();

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraController == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: CameraPreview(
                _cameraController!,
            ),
          ),
          Positioned(
            left: 15,
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isRecording)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_recordedTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_recordedTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _onRecordButtonPressed,
                          icon: Icon(
                            isRecording ? Icons.stop : Icons.fiber_manual_record,
                            color: isRecording ? Colors.red : Colors.white,
                            size: 60,
                          ),
                        ),
                      ),

                ),

              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: IconButton(
              onPressed: _toggleCamera,
              icon: Icon(
                Icons.flip_camera_ios_outlined,
                color: Colors.white,
                size: 50,
              ),
            ),)
        ],
      ),
    );
  }
}
