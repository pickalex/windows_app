class VideoSource {
  final String name; // e.g., "Line 1 (HD)", "Line 2 (HLS)"
  final String url;

  VideoSource({required this.name, required this.url});
}

class VideoItem {
  final String title;
  final String description;
  final String coverUrl; // Optional: for a poster image
  final List<VideoSource> sources;

  VideoItem({
    required this.title,
    required this.description,
    this.coverUrl = '',
    required this.sources,
  });
}
