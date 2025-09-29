import 'package:flutter/material.dart';
import 'package:workout_app/data/app_colors.dart';

class AnimatedGradientText extends StatefulWidget {
  const AnimatedGradientText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 3),
    this.colors = const [Color(0xFFC72CF7), Color(0xFF2EB3E5)],
    this.highlightColor = const Color(0xFF8054F2),
    this.enableGlow = true,
    this.glowRadius = 12,
  });

  final String text;
  final TextStyle style;
  final Duration duration;
  final List<Color> colors;
  final Color highlightColor;
  final bool enableGlow;
  final double glowRadius;

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            final double left =
                -bounds.width + (bounds.width * 2 * _curved.value);
            final Rect animatedRect = Rect.fromLTWH(
              left,
              0,
              bounds.width * 2,
              bounds.height,
            );

            final LinearGradient g = LinearGradient(colors: widget.colors);
            return g.createShader(animatedRect);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            widget.text,
            style: widget.style.copyWith(
              color: AppColors.neonCyan,
              shadows:
                  widget.enableGlow
                      ? <Shadow>[
                        Shadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.75),
                          offset: Offset.zero,
                        ),
                        Shadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.6),
                          offset: Offset.zero,
                        ),
                        Shadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.5),
                          offset: Offset.zero,
                        ),
                      ]
                      : null,
            ),
          ),
        );
      },
    );
  }
}


