import 'package:flutter/material.dart';

import '../../../points/data/models/tour_point_model.dart';

class PointCard extends StatelessWidget {
  const PointCard({super.key, required this.point, this.onTap});

  final TourPointModel point;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        child: Icon(Icons.place, color: Theme.of(context).colorScheme.onPrimary),
      ),
      title: Text(point.title),
      subtitle: Text(point.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
