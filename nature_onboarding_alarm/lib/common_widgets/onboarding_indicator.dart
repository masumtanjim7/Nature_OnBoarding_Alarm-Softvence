import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int index;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: active ? 20 : 8,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.dotInactive,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
