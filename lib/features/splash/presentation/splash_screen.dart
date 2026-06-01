import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/config/app_identity.dart';
import '../../../core/theme/app_colors.dart';
import '../../progress/providers/progress_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    ref.read(progressProvider.future).then((progress) {
      final nextRoute = progress.onboardingSeen ? AppRoutes.main : AppRoutes.onboarding;
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(nextRoute);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.backgroundSecondary],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.cardHighlighted,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.explore, size: 44, color: AppColors.teal),
              ),
              const SizedBox(height: 24),
              Text(AppIdentity.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(AppIdentity.tagline, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}