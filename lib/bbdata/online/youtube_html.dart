
import 'dart:developer';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// Future<String> fetchVideoTitle(String videoUrl) async {
//   final response = await http.get(Uri.parse(videoUrl)).timeout(const Duration(seconds: 30));
  
//   if (response.statusCode == 200) {
//     final document = parser.parse(response.body);
    
//     String title = document.getElementsByTagName('title')[0].text;
//     if (title != "") {
//       return title.split(' - ')[0];
//     } else {
//       throw Exception('Title not found');
//     }
//   } else {
//     throw Exception('Failed to load video page');
//   }
// }

Future<String> fetchVideoTitle(String url) async {
    try {
      var yt = YoutubeExplode();
      var videoId = VideoId(url);
      var video = await yt.videos.get(videoId);

      String title = video.title;
      return title;
    } catch (e) {
      log("$e");
      return "";
    }
  }

// String getVideoThumbnailUrl(String videoUrl) {
//   final Uri uri = Uri.parse(videoUrl);
//   final videoId = uri.queryParameters['v'];
//   return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
// }

Future<String> getVideoThumbnailUrl(String url) async {
    try {
      var yt = YoutubeExplode();
      var videoId = VideoId(url);
      var video = await yt.videos.get(videoId);

      String? imageUrl = video.thumbnails.highResUrl;
      return imageUrl;
    } catch (e) {
      log("$e");
      return "";
    }
  }