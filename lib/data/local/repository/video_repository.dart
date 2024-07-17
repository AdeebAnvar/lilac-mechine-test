abstract class VideoRepository {
  Future<List<String>> fetchVideos();
  Future<String> downloadVideo(String fileName, String url);
}
