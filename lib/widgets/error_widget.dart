import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class WeatherErrorWidget extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  State<WeatherErrorWidget> createState() => _WeatherErrorWidgetState();
}

class _WeatherErrorWidgetState extends State<WeatherErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _bounceAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AnimatedBuilder(
          animation: _bounceAnim,
          builder: (_, child) => Transform.scale(
            scale: _bounceAnim.value,
            child: child,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.card2,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_rounded,
                    color: AppColors.textSecondary, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops!',
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('Try Again',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}