# Rota Viva

Rota Viva é um protótipo de aplicativo Flutter focado em turismo e roteiros interativos.

## Resumo

- Propósito: guiar usuários por rotas turísticas, pontos de interesse, áudio-guia, check-in por localização e aspectos de gamificação.
- Versão: protótipo / primeira entrega

## Tecnologias

- Flutter & Dart
- State management: Riverpod
- Local persistence: SharedPreferences (primeira versão)
- Localização: Geolocator
- Áudio: just_audio
- Fonts: google_fonts

## O que está implementado nesta versão

- Splash screen e Onboarding (flag persistente)
- Navegação principal com 5 abas: Home, Rotas, Mapa, Conquistas, Perfil
- Listagem de rotas e detalhes de rotas
- Detalhes de pontos com scaffold para áudio-guia e check-in por proximidade
- Provedor de localização com cálculo de distância
- Mock JSON em `assets/data/` (`routes.json`, `points.json`, `achievements.json`)

## Como rodar localmente

Pré-requisitos:
- Flutter SDK (testado com Flutter 3.41.9)
- Dispositivo físico ou emulador configurado

Instalação e execução:

```bash
flutter pub get
flutter run
```

Executar testes:

```bash
flutter test
```

## Estrutura do projeto

- `lib/` — código fonte organizado por features
- `lib/core/` — tema, widgets compartilhados e utilitários
- `lib/features/` — features (routes, points, map, achievements, profile, etc.)
- `assets/data/` — mocks JSON

## Notas para desenvolvedores

- Os diretórios `assets/images/` e `assets/audio/` existem como placeholders — adicione mídias reais conforme necessário.
- A persistência de progresso e flag de onboarding usa `SharedPreferences` na primeira versão; podemos migrar para `Hive` se preferir armazenar estruturas mais complexas.
- A integração de mapas (Google Maps / Mapbox) está como placeholder; é necessário adicionar chave de API e pacote correspondente para ativar o mapa.

## Contribuições

Se quiser que eu faça o push deste projeto para o repositório remoto e crie uma branch específica ou sobrescreva o `main`, confirme a estratégia (push normal, nova branch ou force push). Não irei forçar sobrescrita sem sua permissão.

## Licença
Adicione uma licença se quiser tornar este projeto público e aceitar contribuições.

---

Se quiser, eu posso também adicionar badges, screenshots (placeholders adicionados) e um `CONTRIBUTING.md` com orientações de contribuição.
