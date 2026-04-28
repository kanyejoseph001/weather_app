import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/forecast_model.dart';

class HourlyForecast extends StatefulWidget {
  final ForecastModel forecast;
  const HourlyForecast({super.key, required this.forecast});

  @override
  State<HourlyForecast> createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  @override
  Widget build(BuildContext context) {
    final hourly = widget.forecast.items.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOURLY FORECAST',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: hourly.length,
              itemBuilder: (context, index) {
                final item = hourly[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + index * 80),
                  curve: Curves.easeOut,
                  builder: (_, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  ),
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          index == 0
                              ? 'Now'
                              : DateFormat('h a').format(item.dateTime),
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        CachedNetworkImage(
                          imageUrl: item.iconUrl,
                          width: 32,
                          height: 32,
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.cloud, color: Colors.white, size: 24),
                        ),
                        Text(
                          '${item.temperature.round()}°',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}