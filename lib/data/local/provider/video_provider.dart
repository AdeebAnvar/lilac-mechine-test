import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:lilac_test/data/local/repository/video_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoProvider extends VideoRepository {
  @override
  Future<List<String>> fetchVideos() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.dropboxapi.com/2/files/list_folder'),
        headers: {
          // 'Authorization': 'Bearer $accessoken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path': '/videos',
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<String> videoUrls = [];
        for (var entry in data['entries']) {
          if (entry['.tag'] == 'file' && entry['name'].endsWith('.mp4')) {
            final linkResponse = await http.post(
              Uri.parse('https://api.dropboxapi.com/2/files/get_temporary_link'),
              headers: {
                // 'Authorization': 'Bearer $accessoken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'path': entry['path_display'],
              }),
            );

            if (linkResponse.statusCode == 200) {
              final linkData = jsonDecode(linkResponse.body);
              videoUrls.add(linkData['link']);
            }
          }
        }
        log('Video Urls : ${videoUrls}');
        return videoUrls;
      } else {
        print('rfrw');
        return [];
      }
    } catch (e) {
      log('csd $e');
      return [];
    }
  }

  @override
  Future<String> downloadVideo(String fileName, String url) async {
    String text = 'Downloading.....';
    try {
      if (await _requestPermission(Permission.storage)) {
        String fileName = path.basename(url);

        Directory? appDocDir = await getExternalStorageDirectory();
        String savePath = '${appDocDir!.path}/$fileName';

        var response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          File file = File(savePath);
          await file.writeAsBytes(response.bodyBytes);
          return 'Downloaded';
        } else {
          return 'Downloading failed';
        }
      } else {
        return 'permission denied';
      }
    } catch (e) {
      return '';
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
