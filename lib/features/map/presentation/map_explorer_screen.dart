import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../points/providers/points_provider.dart';
import '../providers/location_provider.dart';
import 'widgets/map_placeholder.dart';

class MapExplorerScreen extends ConsumerWidget {
  const MapExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mapa', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const MapPlaceholder(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => ref.read(locationProvider.notifier).requestLocation(),
                  child: const Text('Centralizar localização'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Abrir rota ativa'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: points.when(
              data: (items) => ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(items[index].title),
                  subtitle: Text(items[index].shortDescription),
                ),
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemCount: items.length,
              ),
              loading: () => const LoadingState(),
              error: (_, _) => const EmptyState(title: 'Mapa indisponível', subtitle: 'Não foi possível carregar os pontos.'),
            ),
          ),
        ],
      ),
    );
  }
}
