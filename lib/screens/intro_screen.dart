import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'map_screen.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller =
        VideoPlayerController.asset('assets/videos/introQuestCardQI.mp4')
          ..initialize().then((_) {
            setState(() {
              _isVideoInitialized = true;
            });
            _controller.setVolume(0.0);
            _controller.setLooping(false);
            _controller.play();
          });

    _controller.addListener(_checkVideoEnd);
  }

  void _checkVideoEnd() {
    if (_controller.value.isInitialized &&
        !_controller.value.isPlaying &&
        _controller.value.position >= _controller.value.duration) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (_hasNavigated) return;

    setState(() {
      _hasNavigated = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isVideoInitialized)
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          Positioned(
            bottom: 40,
            right: 20,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                backgroundColor: Colors.black.withAlpha((255 * 0.5).round()),
              ),
              onPressed: _navigateToHome,
              child: const Text('Pular Intro >>'),
            ),
          ),
        ],
      ),
    );
  }
}
