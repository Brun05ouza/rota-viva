import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../achievements/data/models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.achievement});

  final AchievementModel achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final unlocked = achievement.isUnlocked;

    return Card(
      child: Opacity(
        opacity: unlocked ? 1 : 0.62,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: unlocked
                ? colorScheme.primary.withValues(alpha: 0.18)
                : Colors.white10,
            child: Icon(
              unlocked ? _iconFor(achievement.icon) : Icons.lock_outline,
              color: unlocked ? colorScheme.primary : Colors.white70,
            ),
          ),
          title: Text(achievement.title),
          subtitle: Text(_subtitle),
          trailing: Text(unlocked ? 'Desbloqueada' : 'Bloqueada'),
        ),
      ),
    );
  }

  String get _subtitle {
    if (!achievement.isUnlocked || achievement.unlockedAt == null) {
      return achievement.description;
    }

    final parsed = DateTime.tryParse(achievement.unlockedAt!);
    if (parsed == null) {
      return '${achievement.description}\nDesbloqueada em ${achievement.unlockedAt}';
    }

    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    return '${achievement.description}\nDesbloqueada em $formatted';
  }

  IconData _iconFor(String icon) {
    return switch (icon) {
      'location_on' => Icons.location_on,
      'explore' => Icons.explore,
      'verified' => Icons.verified,
      'military_tech' => Icons.military_tech,
      'menu_book' => Icons.menu_book,
      'museum' => Icons.museum,
      _ => Icons.emoji_events,
    };
  }
}
