import 'package:flutter/material.dart';

import '../../../points/data/models/tour_point_model.dart';

enum PointCardStatus { available, visited, locked }

class PointCard extends StatelessWidget {
  const PointCard({
    super.key,
    required this.point,
    this.onTap,
    this.status = PointCardStatus.available,
    this.distanceMeters,
  });

  final TourPointModel point;
  final VoidCallback? onTap;
  final PointCardStatus status;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locked = status == PointCardStatus.locked;
    final visited = status == PointCardStatus.visited;
    final color = visited
        ? colorScheme.primary
        : locked
        ? Colors.white38
        : colorScheme.secondary;
    final icon = visited
        ? Icons.check
        : locked
        ? Icons.lock_outline
        : Icons.place;

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.18),
          child: Icon(icon, color: color),
        ),
        title: Text(point.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              point.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusBadge(label: _statusLabel, icon: icon),
                if (distanceMeters != null)
                  _StatusBadge(
                    label: '${distanceMeters!.toStringAsFixed(0)} m',
                    icon: Icons.near_me_outlined,
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          locked ? Icons.lock_outline : Icons.chevron_right,
          color: locked ? Colors.white38 : null,
        ),
      ),
    );
  }

  String get _statusLabel {
    return switch (status) {
      PointCardStatus.available => 'Disponível',
      PointCardStatus.visited => 'Visitado',
      PointCardStatus.locked => 'Bloqueado',
    };
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
