import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _iconScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.elasticOut));
    _iconOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _iconController, curve: const Interval(0, 0.5)));
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
            CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _iconController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _iconController,
              builder: (_, __) => Opacity(
                opacity: _iconOpacity.value,
                child: Transform.scale(
                  scale: _iconScale.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.wb_sunny_rounded,
                        color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            AnimatedBuilder(
              animation: _textController,
              builder: (_, __) => Opacity(
                opacity: _textOpacity.value,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      Text('SkyWatch',
                          style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text('Your personal weather companion',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
