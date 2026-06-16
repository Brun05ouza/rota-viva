# Rota Viva

Rota Viva é um protótipo Flutter para turismo imersivo e gamificado. O app guia visitantes por rotas turísticas, pontos de interesse, check-in por proximidade, progresso local e conquistas desbloqueáveis.

## Resumo do Projeto

O MVP foi criado para validar uma experiência de exploração urbana com conteúdo local em JSON. A primeira versão funciona sem backend: rotas, pontos e conquistas são carregados de assets, enquanto onboarding, progresso e conquistas desbloqueadas são salvos localmente com `SharedPreferences`.

## Funcionalidades

- Splash screen com animação de entrada.
- Onboarding com persistência local.
- Navegação principal com abas: Home, Mapa, Rotas, Conquistas e Perfil.
- Home com saudação, rota em destaque, rotas recomendadas, pontos próximos e progresso ativo.
- Listagem de rotas com busca e filtros por categoria.
- Detalhe de rota com imagem, descrição, distância, duração, dificuldade, timeline de pontos e progresso real.
- Detalhe de ponto com imagem, categoria, tags, história, curiosidades, áudio-guia opcional e status de check-in.
- Check-in por proximidade usando localização do dispositivo.
- Mapa em modo preview com lista inferior, cards flutuantes e estrutura pronta para Google Maps ou Mapbox.
- Conquistas com regras automáticas, status bloqueado/desbloqueado e data de desbloqueio.
- Perfil com avatar placeholder, nome fictício, métricas locais, limpeza de progresso e opção de rever onboarding.

## Tecnologias

- Flutter e Dart
- Riverpod para gerenciamento de estado
- SharedPreferences para persistência local
- Geolocator para localização
- just_audio para áudio-guia
- google_fonts para tipografia
- JSON local em `assets/data/`

## Estrutura

- `lib/app/`: configuração da aplicação e rotas.
- `lib/core/`: tema, widgets compartilhados e utilitários.
- `lib/features/`: módulos de produto, como home, rotas, pontos, mapa, conquistas, progresso e perfil.
- `assets/data/`: dados mockados de rotas, pontos e conquistas.
- `assets/images/`: espaço reservado para imagens reais.
- `assets/audio/`: espaço reservado para áudios reais.
- `test/`: testes automatizados do fluxo principal.

## Como Rodar

Pré-requisitos:

- Flutter SDK 3.41.9 ou compatível com Dart 3.11.5
- Emulador, navegador ou dispositivo físico configurado

Comandos:

```bash
flutter pub get
flutter run
```

Testes e análise:

```bash
flutter analyze
flutter test
```

## Observações

- As imagens e áudios reais ainda precisam ser adicionados aos diretórios de assets.
- O mapa atual é um preview visual; a estrutura está preparada para integração futura com Google Maps ou Mapbox.
- Para builds Android/iOS com localização, mantenha as permissões nativas configuradas.

## Melhorias Futuras

- Adicionar mídias reais para rotas e pontos.
- Integrar mapa real com marcadores e rotas.
- Suportar múltiplos idiomas.
- Adicionar autenticação opcional e sincronização entre dispositivos.
- Criar modo offline com download de pacotes de rota.
- Evoluir persistência local para Hive, Isar ou SQLite se os dados ficarem mais complexos.
