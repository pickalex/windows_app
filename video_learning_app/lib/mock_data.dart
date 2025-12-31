import 'video_model.dart';

// Mock data simulating a movie with multiple playback sources/lines.
final VideoItem mockVideoData = VideoItem(
  title: 'Big Buck Bunny (2008)',
  description:
      'A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel, who are determined to squelch his happiness.',
  coverUrl: 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Big_buck_bunny_poster_big.jpg',
  sources: [
    VideoSource(
      name: 'Source 1: Official (MP4)',
      url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
    VideoSource(
      name: 'Source 2: Mirror (HLS)',
      // Note: This is a different video (Apple Test) used just to demonstrate switching mechanism
      // because stable mirrors of BBB in HLS are rare. In a real app, this would be the same content.
      url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
    ),
    VideoSource(
      name: 'Source 3: Backup (MP4)',
      // Using Sintel as a placeholder for a "Backup" line to show the switch actually changes content/url
      url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    ),
  ],
);
