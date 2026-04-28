import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/weather_details.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_widget.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cache = ref.read(cacheServiceProvider);
      final lastCity = cache.getLastCity() ?? 'Lagos';
      ref.read(weatherProvider.notifier).loadWeather(lastCity);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getBgColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': return const Color(0xFF1A237E);
      case 'clouds': return const Color(0xFF263238);
      case 'rain':
      case 'drizzle': return const Color(0xFF0D47A1);
      case 'thunderstorm': return const Color(0xFF1A0033);
      case 'snow': return const Color(0xFF1E2A3A);
      default: return AppColors.bg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);

    if (weatherState.weather != null && !_fadeController.isCompleted) {
      _fadeController.forward();
    }

    final bgColor = weatherState.weather != null
        ? _getBgColor(weatherState.weather!.condition)
        : AppColors.bg;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor, AppColors.bg],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, weatherState),
              Expanded(
                child: _buildBody(weatherState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WeatherState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(DateTime.now()),
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              if (state.weather != null)
                Text(
                  '${state.weather!.cityName}, ${state.weather!.country}',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
            ],
          ),
          Row(
            children: [
              if (state.isOffline)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_off, color: Colors.orange, size: 12),
                      const SizedBox(width: 4),
                      Text('Offline',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.my_location_rounded, color: Colors.white),
                onPressed: () =>
                    ref.read(weatherProvider.notifier).loadByLocation(),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, animation, __) => const SearchScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: animation, curve: Curves.easeOut)),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(WeatherState state) {
    if (state.isLoading) return const ShimmerLoading();

    if (state.error != null && state.weather == null) {
      return WeatherErrorWidget(
        message: state.error!,
        onRetry: () => ref.read(weatherProvider.notifier).retry(),
      );
    }

    if (state.weather == null) return const SizedBox();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(weatherProvider.notifier).retry();
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeatherCard(weather: state.weather!),
              const SizedBox(height: 24),
              if (state.forecast != null) ...[
                HourlyForecast(forecast: state.forecast!),
                const SizedBox(height: 24),
                DailyForecast(forecast: state.forecast!),
                const SizedBox(height: 24),
              ],
              WeatherDetails(weather: state.weather!),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
