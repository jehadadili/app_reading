import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart'; // Add this package

class DownloadManager {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  final Dio _dio = Dio();

  Future<void> startDownload({
    required BuildContext context,
    required String fileUrl,
    required String fileName,
    required Function(double) onProgress,
  }) async {
    bool permissionGranted = await _requestPermissions();

    if (!permissionGranted) {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to download',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isDownloading = true;
      downloadProgress = 0;
      onProgress(downloadProgress);

      final directory = await _getDownloadDirectory();
      if (directory == null) {
        throw Exception('Storage directory not available');
      }

      // Make sure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';
      // Check if file exists and delete it to avoid conflicts
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      await _dio.download(
        fileUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = received / total;
            onProgress(downloadProgress);
          }
        },
      );

      Get.snackbar(
        'Download Complete',
        'Book saved to: $filePath',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () async {
            try {
              // Using open_file package instead of url_launcher
              final result = await OpenFile.open(filePath);
              if (result.type != ResultType.done) {
                Get.snackbar(
                  'Error',
                  'Cannot open the file: ${result.message}',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            } catch (e) {
              Get.snackbar(
                'Error',
                'Cannot open the file: $e',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Open', style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Download Error',
        'Could not download the book: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading = false;
      onProgress(downloadProgress);
    }
  }

  Future<bool> _requestPermissions() async {
    if (GetPlatform.isIOS) {
      return true;
    }

    if (GetPlatform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // For Android 13+
        var status = await Permission.mediaLibrary.request();
        return status.isGranted;
      } else if (androidInfo.version.sdkInt >= 29) {
        // For Android 10+
        return true; // Scoped storage doesn't need explicit permission
      } else {
        // For Android 9 and below
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    return false;
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (GetPlatform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else if (GetPlatform.isAndroid) {
      // Try to get the Downloads directory for Android 10+
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 29) {
        // For Android 10+ use app-specific directory
        Directory? appDir = await getExternalStorageDirectory();
        
        // Create a specific folder for downloads if it doesn't exist
        if (appDir != null) {
          final downloadsDir = Directory('${appDir.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return downloadsDir;
        }
        return await getApplicationDocumentsDirectory();
      } else {
        // For Android 9 and below
        try {
          Directory? externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            return externalDir;
          }
        } catch (e) {
          print("Error getting external storage directory: $e");
        }
        
        // Fallback to application documents directory
        return await getApplicationDocumentsDirectory();
      }
    }
    
    return await getApplicationDocumentsDirectory();
  }
}