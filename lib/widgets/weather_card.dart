import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  final WeatherModel weather;
  const WeatherCard({super.key, required this.weather});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void didUpdateWidget(WeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weather.cityName != widget.weather.cityName) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacityAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              // Weather icon
              CachedNetworkImage(
                imageUrl: widget.weather.iconUrl,
                width: 100,
                height: 100,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.wb_sunny, color: AppColors.sunny, size: 80),
              ),
              // Temperature
              Text(
                '${widget.weather.temperature.round()}°',
                style: GoogleFonts.inter(
                  fontSize: 80,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.weather.description.toUpperCase(),
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H:${widget.weather.tempMax.round()}°',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 16),
                  Text('L:${widget.weather.tempMin.round()}°',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Feels like ${widget.weather.feelsLike.round()}°',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}