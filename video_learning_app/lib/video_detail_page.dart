import 'package:flutter/material.dart';
import 'video_model.dart';
import 'embedded_player.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoItem video;

  const VideoDetailPage({super.key, required this.video});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  // Currently selected source index
  int _selectedSourceIndex = 0;

  void _switchSource(int index) {
    if (index != _selectedSourceIndex) {
      setState(() {
        _selectedSourceIndex = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${widget.video.sources[index].name}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final currentSource = video.sources[_selectedSourceIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
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
              child: EmbeddedPlayer(
                key: ValueKey(currentSource.url),
                videoUrl: currentSource.url,
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
                  video.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Category & Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.category,
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  video.description,
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
                  children: List.generate(video.sources.length, (index) {
                    final source = video.sources[index];
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
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
