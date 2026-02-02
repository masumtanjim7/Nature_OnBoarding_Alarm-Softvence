import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_colors.dart';

class OnboardingVideoPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String videoAsset;

  const OnboardingVideoPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.videoAsset,
  });

  @override
  State<OnboardingVideoPage> createState() => _OnboardingVideoPageState();
}

class _OnboardingVideoPageState extends State<OnboardingVideoPage> {
  late final VideoPlayerController _vc;

  @override
  void initState() {
    super.initState();
    _vc = VideoPlayerController.asset(widget.videoAsset)
      ..setLooping(true)
      ..setVolume(0.0) // video silent; bg music plays
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _vc.play();
      });
  }

  @override
  void dispose() {
    _vc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // background gradient similar to your Figma
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_vc.value.isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _vc.value.size.width,
              height: _vc.value.size.height,
              child: VideoPlayer(_vc),
            ),
          )
        else
          Container(color: AppColors.bg),

        // overlay for readability
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent, Colors.black87],
            ),
          ),
        ),

        // content (top image card vibe + bottom text area)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              children: [
                const SizedBox(height: 46),

                // Video "card" area like Figma (rounded)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      color: Colors.black.withOpacity(0.12),
                      // video already fills; this is just for rounded shape
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
