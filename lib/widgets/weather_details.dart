import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/weather_model.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherModel weather;
  const WeatherDetails({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WEATHER DETAILS',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _DetailCard(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${weather.humidity}%',
              color: AppColors.rainy,
            ),
            _DetailCard(
              icon: Icons.air,
              label: 'Wind Speed',
              value: '${weather.windSpeed.round()} m/s',
              color: AppColors.accent,
            ),
            _DetailCard(
              icon: Icons.visibility_outlined,
              label: 'Visibility',
              value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
              color: AppColors.cloudy,
            ),
            _DetailCard(
              icon: Icons.compress,
              label: 'Pressure',
              value: '${weather.pressure} hPa',
              color: AppColors.stormy,
            ),
            _DetailCard(
              icon: Icons.wb_sunny_outlined,
              label: 'Sunrise',
              value: DateFormat('h:mm a').format(weather.sunrise),
              color: AppColors.sunny,
            ),
            _DetailCard(
              icon: Icons.nights_stay_outlined,
              label: 'Sunset',
              value: DateFormat('h:mm a').format(weather.sunset),
              color: Colors.deepPurpleAccent,
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}