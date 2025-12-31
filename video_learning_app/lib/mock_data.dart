import 'video_model.dart';

// Reusable source constants
final _sourceBBB = [
  VideoSource(
      name: 'Official Source (MP4)',
      url:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
  VideoSource(
      name: 'Mirror Line (HLS)',
      url:
          'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8'),
];

final _sourceSintel = [
  VideoSource(
      name: 'Official Source (MP4)',
      url:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
];

final _sourceTears = [
  VideoSource(
      name: 'Official Source (MP4)',
      url:
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
];

// Mock Library
final List<VideoItem> mockLibrary = [
  VideoItem(
    id: '1',
    title: 'Big Buck Bunny',
    description:
        'A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel.',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/commons/c/c5/Big_buck_bunny_poster_big.jpg',
    category: 'Animation',
    isPopular: true,
    sources: _sourceBBB,
  ),
  VideoItem(
    id: '2',
    title: 'Sintel',
    description:
        'A lonely young woman, Sintel, helps and befriends a dragon, whom she calls Scales. A fantasy quest.',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/commons/8/8f/Sintel_poster.jpg',
    category: 'Fantasy',
    isPopular: true,
    sources: _sourceSintel,
  ),
  VideoItem(
    id: '3',
    title: 'Tears of Steel',
    description:
        'A group of warriors and scientists gather at the Oude Kerk in Amsterdam to stage a crucial event from the past.',
    coverUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Tears_of_Steel_Poster.jpg/800px-Tears_of_Steel_Poster.jpg',
    category: 'Sci-Fi',
    isPopular: true,
    sources: _sourceTears,
  ),
  // Simulating more content by reusing sources with different metadata
  VideoItem(
    id: '4',
    title: 'Cyber Rabbit 2077',
    description: 'In a futuristic world, a cybernetic rabbit fights for justice. (Demo Content)',
    coverUrl: 'https://via.placeholder.com/300x450/0000FF/808080?text=Cyber+Rabbit',
    category: 'Sci-Fi',
    isPopular: false,
    sources: _sourceBBB,
  ),
  VideoItem(
    id: '5',
    title: 'Dragon Heart: Origins',
    description: 'The untold story of how the dragon scales were forged. (Demo Content)',
    coverUrl: 'https://via.placeholder.com/300x450/FF0000/FFFFFF?text=Dragon+Heart',
    category: 'Fantasy',
    isPopular: false,
    sources: _sourceSintel,
  ),
  VideoItem(
    id: '6',
    title: 'Amsterdam Protocol',
    description: 'A spy thriller set in the heart of Amsterdam. (Demo Content)',
    coverUrl: 'https://via.placeholder.com/300x450/000000/FFFFFF?text=Protocol',
    category: 'Action',
    isPopular: true,
    sources: _sourceTears,
  ),
  VideoItem(
    id: '7',
    title: 'Forest Adventure',
    description: 'Exploration of the deep magical forest. (Demo Content)',
    coverUrl: 'https://via.placeholder.com/300x450/008000/FFFFFF?text=Forest',
    category: 'Animation',
    isPopular: false,
    sources: _sourceBBB,
  ),
  VideoItem(
    id: '8',
    title: 'Space Frontier',
    description: 'Journey to the edge of the universe. (Demo Content)',
    coverUrl: 'https://via.placeholder.com/300x450/4B0082/FFFFFF?text=Space',
    category: 'Sci-Fi',
    isPopular: true,
    sources: _sourceTears,
  ),
];
