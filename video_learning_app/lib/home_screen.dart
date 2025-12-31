import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'video_model.dart';
import 'video_detail_page.dart';
import 'video_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Action', 'Sci-Fi', 'Animation', 'Fantasy'];

  List<VideoItem> get _filteredVideos {
    if (_selectedCategory == 'All') {
      return mockLibrary;
    }
    return mockLibrary.where((v) => v.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Video Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: VideoSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: _categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 2. Popular Section (Only show if "All" is selected, just for layout variety)
            if (_selectedCategory == 'All') ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  'Popular Now',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: mockLibrary.where((v) => v.isPopular).length,
                  itemBuilder: (context, index) {
                    final video = mockLibrary.where((v) => v.isPopular).toList()[index];
                    return _buildVideoCard(video, width: 140);
                  },
                ),
              ),
            ],

            // 3. Main List / Category Results
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                _selectedCategory == 'All' ? 'All Videos' : '$_selectedCategory Movies',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredVideos.length,
              itemBuilder: (context, index) {
                final video = _filteredVideos[index];
                return _buildHorizontalVideoCard(video);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // A vertical card (poster style)
  Widget _buildVideoCard(VideoItem video, {double width = 120}) {
    return GestureDetector(
      onTap: () => _navigateToDetail(video),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(video.coverUrl),
                    fit: BoxFit.cover,
                    onError: (e, s) {}, // Handle error silently
                  ),
                  color: Colors.grey[300],
                ),
                // Fallback icon if image fails
                child: video.coverUrl.isEmpty
                    ? const Center(child: Icon(Icons.movie, size: 40))
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              video.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              video.category,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // A horizontal card (list tile style)
  Widget _buildHorizontalVideoCard(VideoItem video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => _navigateToDetail(video),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: NetworkImage(video.coverUrl),
                  fit: BoxFit.cover,
                  onError: (e, s) {},
                ),
                color: Colors.grey[300],
              ),
              child: video.coverUrl.isEmpty
                  ? const Center(child: Icon(Icons.movie))
                  : null,
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Play Icon
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.play_circle_outline, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(VideoItem video) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoDetailPage(video: video)),
    );
  }
}
