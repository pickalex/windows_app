import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'video_model.dart';
import 'video_detail_page.dart';

class VideoSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  Widget _buildResultsOrSuggestions(BuildContext context) {
    final results = mockLibrary.where((video) {
      return video.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (query.isEmpty) {
      return const Center(
        child: Text('Enter a movie name...'),
      );
    }

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found.'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final video = results[index];
        return ListTile(
          leading: Image.network(
            video.coverUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.movie, size: 50),
          ),
          title: Text(video.title),
          subtitle: Text(video.category),
          onTap: () {
            // Close search and navigate to detail
            // Note: We usually close search first or push directly.
            // Here we push directly on top of search.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoDetailPage(video: video),
              ),
            );
          },
        );
      },
    );
  }
}
