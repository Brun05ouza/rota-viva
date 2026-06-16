# Apresentação do Projeto Rota Viva

## Resumo

Rota Viva é um aplicativo Flutter de turismo interativo. Ele ajuda visitantes a descobrir rotas, conhecer pontos turísticos, fazer check-in por proximidade e acompanhar conquistas de exploração.

## Principais Telas

- Splash: entrada com identidade visual do app.
- Onboarding: introdução em três passos.
- Home: saudação, rota em destaque, rotas recomendadas, pontos próximos e progresso.
- Rotas: busca, filtros por categoria e cards de rota.
- Detalhe da rota: imagem, metadados, timeline de pontos e progresso real.
- Mapa: preview com cards flutuantes, lista de pontos e ação de centralizar localização.
- Detalhe do ponto: história, curiosidades, áudio-guia opcional e check-in.
- Conquistas: painel de medalhas bloqueadas e desbloqueadas.
- Perfil: avatar, usuário fictício, estatísticas e ações locais.

## Tecnologias Usadas

- Flutter
- Dart
- Riverpod
- SharedPreferences
- Geolocator
- just_audio
- google_fonts

## Funcionalidades Implementadas

- Navegação completa por abas.
- Dados mockados locais em JSON.
- Persistência local de onboarding, progresso e conquistas.
- Check-in por raio de proximidade.
- Progresso real por rota.
- Regras de conquistas.
- Estados visuais para pontos e conquistas.
- Testes automatizados do fluxo principal.

## Prints Sugeridos

- Splash com logo.
- Primeira tela do onboarding.
- Home com rota em destaque.
- Lista de rotas com busca.
- Detalhe de rota com timeline.
- Mapa preview com cards flutuantes.
- Detalhe de ponto com status de check-in.
- Tela de conquistas.
- Perfil do usuário.

## Melhorias Futuras

- Inserir imagens e áudios reais.
- Integrar Google Maps ou Mapbox.
- Adicionar rotas multilíngues.
- Criar autenticação opcional.
- Sincronizar progresso em backend.
- Criar modo offline com pacotes de mídia.
