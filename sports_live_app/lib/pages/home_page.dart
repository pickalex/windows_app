import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'live_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _channelController = TextEditingController(text: 'sports_match_1');
  bool _isBroadcaster = false;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  Future<void> _joinChannel() async {
    if (_channelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a channel name')),
      );
      return;
    }

    // Request permissions for camera and microphone
    await [Permission.camera, Permission.microphone].request();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          channelName: _channelController.text,
          isBroadcaster: _isBroadcaster,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Live Stream'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_soccer, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              TextField(
                controller: _channelController,
                decoration: const InputDecoration(
                  labelText: 'Channel Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.live_tv),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Role: ', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isBroadcaster,
                    onChanged: (value) {
                      setState(() {
                        _isBroadcaster = value;
                      });
                    },
                  ),
                  Text(
                    _isBroadcaster ? 'Broadcaster (Host)' : 'Audience (Viewer)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isBroadcaster ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _joinChannel,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Join Live Stream'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
