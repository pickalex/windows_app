class VideoSource {
  final String name; // e.g., "Line 1 (HD)", "Line 2 (HLS)"
  final String url;

  VideoSource({required this.name, required this.url});
}

class VideoItem {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String category; // e.g., "Action", "Sci-Fi", "Drama"
  final bool isPopular;
  final List<VideoSource> sources;

  VideoItem({
    required this.id,
    required this.title,
    required this.description,
    this.coverUrl = '',
    required this.category,
    this.isPopular = false,
    required this.sources,
  });
}
