import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../common_widgets/gradient_button.dart';
import '../../common_widgets/onboarding_indicator.dart';
import '../../constants/app_texts.dart';
import '../../helpers/audio_helper.dart';
import '../location/location_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  VideoPlayerController? _video;
  bool _videoReady = false;
  bool _switching = false;

  final List<String> _videoAssets = const [
    "assets/videos/for_on_boardscreen1.mp4",
    "assets/videos/for_on_boardscreen2.mp4",
    "assets/videos/for_on_boardscreen3.mp4",
  ];

  @override
  void initState() {
    super.initState();

    // Start music after first frame (stable)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioHelper.startBgm();
    });

    _loadVideo(0);
  }

  Future<void> _loadVideo(int index) async {
    if (_switching) return;
    _switching = true;

    setState(() => _videoReady = false);

    final old = _video;
    _video = VideoPlayerController.asset(_videoAssets[index]);

    try {
      await _video!.initialize();
      await _video!.setLooping(true);
      await _video!.setVolume(0);
      await _video!.play();
    } catch (_) {
      // If something fails, avoid crashing.
    }

    // Dispose previous controller AFTER new one starts
    await old?.dispose();

    if (!mounted) return;
    setState(() {
      _videoReady = true;
      _switching = false;
    });
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationScreen()),
    );
  }

  void _next() {
    if (_index < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = AppTexts.onboarding;

    return Scaffold(
      backgroundColor: const Color(0xFF050A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (i) {
                  setState(() => _index = i);
                  _loadVideo(i); // ✅ switch source
                },
                itemBuilder: (_, i) {
                  final p = pages[i];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
                    child: Column(
                      children: [
                        // Rounded video card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (_video != null && _videoReady)
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _video!.value.size.width,
                                      height: _video!.value.size.height,
                                      child: VideoPlayer(_video!),
                                    ),
                                  )
                                else
                                  Container(color: Colors.white12),

                                // overlay gradient
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x22000000),
                                        Color(0x00000000),
                                        Color(0x22000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            p["title"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            p["subtitle"]!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const Spacer(),

                        OnboardingIndicator(count: 3, index: _index),
                        const SizedBox(height: 16),

                        GradientButton(text: "Next", onTap: _next),
                        const SizedBox(height: 18),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
