import 'package:flutter/material.dart';

import '../../../achievements/data/models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});

  final AchievementModel achievement;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(achievement.isUnlocked ? Icons.verified : Icons.lock_outline),
        ),
        title: Text(achievement.title),
        subtitle: Text(achievement.description),
        trailing: Text(achievement.isUnlocked ? 'Desbloqueada' : 'Bloqueada'),
      ),
    );
  }
}
