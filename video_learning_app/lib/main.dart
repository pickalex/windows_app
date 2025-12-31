import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'video_model.dart';
import 'embedded_player.dart';

void main() {
  runApp(const VideoApp());
}

class VideoApp extends StatelessWidget {
  const VideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Source Switcher',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const VideoDetailPage(),
    );
  }
}

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  // Current video being displayed
  final VideoItem _video = mockVideoData;

  // Currently selected source index
  int _selectedSourceIndex = 0;

  void _switchSource(int index) {
    if (index != _selectedSourceIndex) {
      setState(() {
        _selectedSourceIndex = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${_video.sources[index].name}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Video Player Area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              // We pass the key based on the URL to force the widget to rebuild
              // completely when the source changes. This is the simplest way to
              // handle source switching for this demo.
              child: EmbeddedPlayer(
                key: ValueKey(_video.sources[_selectedSourceIndex].url),
                videoUrl: _video.sources[_selectedSourceIndex].url,
              ),
            ),
          ),

          // 2. Info & Source Selection Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Title
                Text(
                  _video.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  _video.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),

                // "Switch Source" Section
                const Text(
                  'Select Source / Line:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(_video.sources.length, (index) {
                    final source = _video.sources[index];
                    final isSelected = index == _selectedSourceIndex;

                    return ChoiceChip(
                      label: Text(source.name),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        if (selected) {
                          _switchSource(index);
                        }
                      },
                      selectedColor: Colors.indigoAccent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tip: If one source is buffering or fails, try switching to another line.',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
