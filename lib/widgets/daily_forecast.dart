import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/forecast_model.dart';

class DailyForecast extends StatelessWidget {
  final ForecastModel forecast;
  const DailyForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final daily = forecast.dailySummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('5-DAY FORECAST',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: daily.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == daily.length - 1;

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 400 + index * 100),
                curve: Curves.easeOut,
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: child,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              index == 0
                                  ? 'Today'
                                  : DateFormat('EEEE').format(item.dateTime),
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl: item.iconUrl,
                            width: 28,
                            height: 28,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.cloud, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${(item.pop * 100).round()}%',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.rainy),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            '${item.tempMax.round()}°',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.tempMin.round()}°',
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.05),
                          indent: 20),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}