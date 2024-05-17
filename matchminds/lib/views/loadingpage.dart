import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import 'package:matchminds/views/homepage.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late double _opacity;
  late AnimationController _animationController;
  late AudioPlayer _audioPlayer; // AudioPlayer instance to play the sound

  @override
  void initState() {
    super.initState();

    _opacity = 0.0;

    // Start fading in the ArenaGo text
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Start rotating animation for loading circles
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initialize the AudioPlayer and play the sound
    _audioPlayer = AudioPlayer();
    _playBackgroundSound();

    // Add a delay of 2 seconds before navigating to the login page
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomaPage()), // Corrected typo in HomePage
      );
    });
  }

  Future<void> _playBackgroundSound() async {
  await _audioPlayer.play(AssetSource('tone.mp3')); // Use AssetSource
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set background color to orange
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fade in ArenaGo text
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: Image.asset(
                'assets/logo.png', // Replace with the path to your logo image
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(height: 16), // Add some space between ArenaGo and loading animation
            // Loading animation with circles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 72, 170, 7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the AudioPlayer instance
    _animationController.dispose();
    super.dispose();
  }
}
