import 'package:flutter/material.dart';

import '../../../points/data/models/tour_point_model.dart';

class RouteTimeline extends StatelessWidget {
  const RouteTimeline({
    super.key,
    required this.points,
    required this.visitedPointIds,
    required this.onPointTap,
  });

  final List<TourPointModel> points;
  final Set<String> visitedPointIds;
  final ValueChanged<TourPointModel> onPointTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(points.length, (index) {
        final point = points[index];
        final visited = visitedPointIds.contains(point.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: visited
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white12,
                    child: Icon(visited ? Icons.check : Icons.place, size: 16),
                  ),
                  if (index != points.length - 1)
                    Container(width: 2, height: 72, color: Colors.white12),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: visited
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.35)
                          : Colors.white10,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(point.shortDescription),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => onPointTap(point),
                        child: const Text('Abrir ponto'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
