import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../common_widgets/gradient_button.dart';
import '../alarm/alarm_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool loading = false;
  Position? pos;

  Future<void> _useCurrentLocation() async {
    setState(() => loading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
        }
        return;
      }

      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() => pos = p);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch location")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AlarmScreen(
          // pass a label to show location
          locationLabel: pos == null
              ? "Add your location"
              : "${pos!.latitude.toStringAsFixed(4)}, ${pos!.longitude.toStringAsFixed(4)}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0A2E), Color(0xFF06113A), Color(0xFF061A3B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 6),

                // top small title
                const Text(
                  "Location",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Welcome! Your Smart\nTravel Alarm",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Stay on schedule and enjoy every\nmoment of your journey.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 22),

                // picture Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Image.asset(
                      "assets/images/alarm_screen.jpg",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        // fallback if not found picture
                        return const Center(
                          child: Text(
                            "assets/images/alarm_screen.jpg",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(),

                // location button
                _OutlinePillButton(
                  text: loading
                      ? "Getting location..."
                      : "Use Current Location",
                  onTap: loading ? null : _useCurrentLocation,
                ),

                const SizedBox(height: 14),

                // home button
                GradientButton(text: "Home", onTap: _goHome),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinePillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _OutlinePillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white24),
          color: Colors.white.withOpacity(0.03),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.location_on_outlined, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
