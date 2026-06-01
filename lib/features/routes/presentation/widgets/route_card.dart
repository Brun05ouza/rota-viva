import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../routes/data/models/tour_route_model.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.route, this.onTap});

  final TourRouteModel route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Image.asset(
                  route.coverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.white10,
                    alignment: Alignment.center,
                    child: const Icon(Icons.landscape_outlined, size: 42),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route.category, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Text(route.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(route.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Meta(label: route.estimatedTime, icon: Icons.schedule),
                      _Meta(label: route.distance, icon: Icons.straighten),
                      _Meta(label: route.difficulty, icon: Icons.terrain),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 14), const SizedBox(width: 4), Text(label)],
      ),
    );
  }
}
