import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../providers/routes_provider.dart';
import 'widgets/route_card.dart';

class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> {
  String query = '';
  String category = 'Todas';

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routesProvider);
    const categories = [
      'Todas',
      'História',
      'Natureza',
      'Cultura',
      'Gastronomia',
      'Religioso',
      'Aventura',
    ];

    return Padding(
      key: const ValueKey('routes-screen'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rotas', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar rota',
            ),
            onChanged: (value) => setState(() => query = value),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = categories[index];
                return ChoiceChip(
                  label: Text(item),
                  selected: category == item,
                  onSelected: (_) => setState(() => category = item),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: routes.when(
              data: (items) {
                final filtered = items.where((route) {
                  final matchesQuery =
                      query.isEmpty ||
                      route.title.toLowerCase().contains(query.toLowerCase());
                  final matchesCategory =
                      category == 'Todas' || route.category == category;
                  return matchesQuery && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    title: 'Nenhuma rota encontrada',
                    subtitle: 'Tente outro termo ou categoria.',
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    final route = filtered[index];
                    return RouteCard(
                      route: route,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.routeDetails, arguments: route.id),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemCount: filtered.length,
                );
              },
              loading: () => const LoadingState(),
              error: (_, _) => const EmptyState(
                title: 'Erro ao carregar rotas',
                subtitle: 'Verifique os dados locais.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
