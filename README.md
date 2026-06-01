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

---

# Perguntas essenciais

Use esta lista para orientar decisões de produto, design e implementação. Responda ou comente cada item durante as próximas reuniões.

## Visão e público
- Qual é o público-alvo primário (turistas estrangeiros, moradores, escolas, visitantes autônomos)?
- Qual é o objetivo principal do app em 3 frases? (ex: guiar, educar, entreter e fidelizar visitantes)
- O app deve funcionar offline? Quais dados mínimos precisam estar disponíveis sem conexão?

## Rotas e pontos
- Que tipo de rotas teremos: histórico, cultural, gastronômico, natureza, personalizadas?
- Como definimos a granularidade de pontos (por rota: 3–10, por cidade: X)?
- Precisamos suportar múltiplas línguas no conteúdo das rotas/pontos? Quais?

## Conteúdo multimídia
- Quais formatos de mídia serão usados para cada ponto? (texto, imagem, galeria, áudio, vídeo)
- Haverá narração profissional para áudio-guia ou TTS (text-to-speech) é aceitável inicialmente?
- Qual é o tamanho máximo aceitável para áudios offline por rota?

## Check-in por localização
- Qual raio de geofencing para check-in é apropriado (metros)?
- Como lidar com falsos positivos/negativos de GPS (p.ex. detecção por proximidade + confirmação pelo usuário)?

## Mapas e localização
- Usaremos Google Maps, Mapbox ou outro? Existe chave/API já disponível?
- Queremos rota em tempo real (direções) ou apenas marcador/visualização?

## Experiência do usuário (UX)
- Precisa de acessibilidade (legendas, contraste, leitura por voz)?
- Quais notificações contextuais são aceitáveis (check-in, conquistas, dicas ao chegar ao ponto)?

## Gamificação e progresso
- Como o usuário ganha pontos/conquistas? Por check-in, completar rota, tempo de áudio escutado?
- Como exibiremos progresso: percentual da rota, medalhas, ranking público?

## Autenticação e privacidade
- O app requer login? Permite uso anônimo com opcional cadastro?
- Quais dados pessoais serão coletados e como serão armazenados (consentimento, política de privacidade)?

## Persistência e sincronização
- Deve sincronizar progresso entre dispositivos/contas (necessita backend)?
- Que dados persistimos localmente com prioridade (progresso, favoritos, downloads offline)?

## Métricas e observabilidade
- Quais métricas mínimas queremos coletar (instalações, rotas iniciadas, check-ins, tempo de áudio)?
- Aceita integração com ferramentas como Firebase Analytics ou similar?

## Performance e limites
- Qual é o alvo mínimo de performance (tempo de abertura, memória, tamanho do APK/APK)?
- Há limitações de rede para público-alvo (p.ex. redes móveis lentas)?

## Testes e qualidade
- Quais cenários devemos automatizar (integração de áudio, simulação de localização, check-in flow)?
- Existe um plano de testes manuais para aceitar rotas e pontos com conteúdo multimídia?

## Lançamento e distribuição
- Pretendemos lançar nas lojas (Google Play / App Store) já na próxima versão? Há contas de developer prontas?
- Precisamos de builds separados para homologação/produção? Políticas de CI/CD?

## Licença e contribuição
- Qual licença de código devemos aplicar (MIT, Apache, proprietária)?
- Como aceitaremos contribuições (pull requests, issues, guidelines)?

## Prioridades imediatas (decisões rápidas)
- Qual a prioridade: áudio-guia offline, check-in por GPS, ou rotas multilíngue?
- Podemos começar com um conjunto piloto de 1–3 rotas com mídia completa para validação?

---

Descrição

Rota Viva é um protótipo criado para orientar visitantes por rotas turísticas com pontos de interesse enriquecidos por texto, imagens e áudio-guia. O projeto foi desenvolvido como um scaffold funcional para validação de produto e testes de usabilidade. Ele inclui telas principais como Splash, Onboarding, navegação por abas, listagem de rotas, detalhes de rota e ponto, um placeholder para mapa e integrações iniciais para localização e áudio.

Como foi desenvolvido

- Linguagem e framework: Flutter e Dart.
- Gerenciamento de estado: Riverpod (flutter_riverpod).
- Persistência local: SharedPreferences (primeira versão para progresso e flags simples).
- Localização: Geolocator (para obter posição e calcular distâncias para check-in).
- Áudio: integração básica com `just_audio` para preparar o áudio-guia.
- Arquitetura: organização por features em `lib/features/` (cada feature tem modelos, repositório, providers e apresentação).
- Dados de exemplo: arquivos JSON em `assets/data/` (`routes.json`, `points.json`, `achievements.json`).

Como rodar

Pré-requisitos:
- Flutter SDK instalado
- Dispositivo/emulador configurado

Comandos:

```bash
flutter pub get
flutter run
```

Executar testes:

```bash
flutter test
```

Observações técnicas

- As pastas `assets/images/` e `assets/audio/` existem como placeholders — adicione arquivos reais conforme necessário e, se necessário, atualize `pubspec.yaml`.
- O mapa está implementado como placeholder; para ativar mapas reais, configure a API (Google Maps/Mapbox) e adicione o pacote correspondente.
- A persistência atual usa `SharedPreferences`; para dados mais complexos, considere migrar para `Hive` ou outro banco local.

Estrutura principal

- `lib/core/`: tema, utilitários e widgets compartilhados.
- `lib/features/`: código por feature (routes, points, map, achievements, profile, etc.).

Contribuição

Pull requests são bem-vindos. Inclua descrição clara das mudanças, como testar e qualquer dependência nova.

Licença

Adicione uma licença se desejar abrir o repositório publicamente para contribuições.
