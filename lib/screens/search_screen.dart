import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  final List<String> _recentCities = [
    'London', 'New York', 'Tokyo', 'Paris', 'Dubai', 'Lagos',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _search(String city) {
    if (city.trim().isEmpty) return;
    ref.read(weatherProvider.notifier).loadWeather(city.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () => _search(_controller.text),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Popular Cities',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 1)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _recentCities.map((city) {
                  return GestureDetector(
                    onTap: () => _search(city),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.card2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(city,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}