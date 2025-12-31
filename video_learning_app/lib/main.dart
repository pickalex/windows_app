import 'package:flutter/material.dart';
import 'player_screen.dart';

void main() {
  runApp(const VideoApp());
}

class VideoApp extends StatelessWidget {
  const VideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Study',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  // Sample video sources from public testing lists
  final Map<String, String> _videoSources = {
    'Big Buck Bunny (MP4)':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'Elephant Dream (MP4)':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'Sintel (MP4)':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'Tears of Steel (MP4)':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'Subaru Outback (MP4)':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
    'Apple HLS Test (M3U8)':
        'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
  };

  String? _selectedSourceKey;

  @override
  void initState() {
    super.initState();
    // Default to the first source
    _selectedSourceKey = _videoSources.keys.first;
    _urlController.text = _videoSources.values.first;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _playVideo() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerScreen(videoUrl: url),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
    }
  }

  void _onSourceChanged(String? newValue) {
    setState(() {
      _selectedSourceKey = newValue;
      if (newValue != null) {
        _urlController.text = _videoSources[newValue]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Video Player'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select a Sample Video Source:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSourceKey,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _videoSources.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    key,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _onSourceChanged,
            ),
            const SizedBox(height: 20),
            const Text(
              'Or Enter Custom URL:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'https://example.com/video.mp4',
                labelText: 'Video URL',
              ),
              maxLines: 3,
              minLines: 1,
              onChanged: (value) {
                // If user types manually, clear the dropdown selection if it doesn't match
                if (_selectedSourceKey != null && value != _videoSources[_selectedSourceKey]) {
                  setState(() {
                    _selectedSourceKey = null;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _playVideo,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Video'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Supported formats: MP4, M3U8 (HLS), etc.\nNote: Ensure the URL is publicly accessible.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
