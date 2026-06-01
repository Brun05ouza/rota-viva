import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/widgets/primary_button.dart';
import '../../progress/providers/progress_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final controller = PageController();
  var index = 0;

  final pages = const [
    ('Descubra rotas incríveis', 'Explore experiências turísticas criadas para transformar sua caminhada em uma jornada.'),
    ('Visite pontos e desbloqueie histórias', 'Chegue perto dos locais, faça check-in e descubra curiosidades, áudios e conteúdos exclusivos.'),
    ('Complete experiências', 'Conclua rotas, acompanhe seu progresso e desbloqueie conquistas durante sua exploração.'),
  ];

  Future<void> _finish() async {
    await ref.read(progressProvider.notifier).setOnboardingSeen();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (value) => setState(() => index = value),
                  itemCount: pages.length,
                  itemBuilder: (context, i) {
                    final (title, subtitle) = pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rota Viva', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 12),
                        Text(title, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == i ? Theme.of(context).colorScheme.primary : Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: index == pages.length - 1 ? 'Começar exploração' : 'Continuar',
                onPressed: () {
                  if (index == pages.length - 1) {
                    _finish();
                  } else {
                    controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}