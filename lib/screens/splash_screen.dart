import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text('🦁', style: TextStyle(fontSize: 70))),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 32),
              
              const Text(
                'WildTails',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
              
              const Text(
                'GHANA',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300, color: Color(0xFFFCD116), letterSpacing: 8),
              ).animate().fadeIn(delay: 500.ms),
              
              const SizedBox(height: 16),
              
              Text(
                'Explore • Protect • Conserve',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
              ).animate().fadeIn(delay: 700.ms),
              
              const SizedBox(height: 60),
              
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.7)),
                ),
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
