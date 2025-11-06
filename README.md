# QuestCardQI

é um jogo de cartas educacional no estilo roguelike deck-builder desenvolvido em Flutter. O objetivo do jogo é derrotar monstros em batalhas por turnos, mas com uma reviravolta: para usar as cartas, o jogador deve responder corretamente a perguntas de múltipla escolha (quizzes).

Este projeto serve como um protótipo funcional para demonstrar a mecânica central do jogo.

## Como Iniciar
Este projeto é construído em Flutter e pode ser executado em dispositivos móveis (Android/iOS) e na Web.

**Pré-requisitos**

-  Ter o Flutter SDK instalado.
-  Um emulador/dispositivo Android ou iOS, ou o Google Chrome para web.


**1. Instalar**

use 
```
flutter pub get
```

**2. Executar no Mobile (Android/iOS - versão com erro no card_in_collection_widget)**

Certifique-se de que um emulador ou dispositivo esteja conectado

```
flutter run
```

**3. Executar na Web (Versão com menos erros)**

Habilite o suporte web (só precisa fazer uma vez)

```
flutter config --enable-web
```

Inicie o app no Chrome

```
flutter run -d chrome
```

## Funcionalidades Criadas

### O estado atual do programa inclui as seguintes funcionalidades:

- **Sistema de Batalha por Turnos:** O jogador e o monstro se alternam em turnos. A lógica é controlada pelo GameController.

- **Mecânica de Quiz:** Para jogar uma carta, o jogador deve responder a um quiz (QuizDialog).

   - **Acerto (Efeito Bônus):** Ativa o efeito mais forte da carta.

   - **Erro (Efeito Base):** Ativa um efeito mais fraco ou penalidade.

- **Combate com Cartas:** As cartas (card_model.dart) podem:

   - Causar dano.

   - Gerar Escudo (playerShield).

   - Curar o jogador.

   - Comprar mais cartas.

   - Aplicar "debuffs" (Vulnerável) e "DoT" (Dano Contínuo, como Veneno).

- **Inimigos (Monstros):** Cada monstro (monster_database.dart) possui seu próprio HP, padrão de ataque e um "pool" de recompensas (cartas) específico.

- **Fluxo de Jogo Completo:** O jogo flui entre:

    - MapScreen: Seleção do oponente.

    - BattleScreen: Onde a batalha ocorre.

    - RewardScreen: (Em caso de vitória) Tela para escolher uma nova carta para o deck.

    - LoseScreen: (Em caso de derrota) Tela com opções de tentar novamente ou voltar ao mapa.

- **Gerenciamento de Deck:** O jogador começa com um deck básico e adiciona novas cartas (_acquiredCards) ao vencer batalhas. O sistema de embaralhar, comprar e descartar está funcional.

- **Interface Reativa:**

    - **HpBar:** Widget reutilizável que mostra HP, HP Máximo e Escudo.

    - **CardInHandWidget:** Animação que "levanta" a carta ao passar o mouse ou tocar, melhorando o feedback visual.

## Estrutura do Projeto e Tecnologias

- **Linguagem:** Dart

- **Framework:** Flutter

- **Gerenciamento de Estado:** Provider (usando ChangeNotifierProvider e GameController como o ChangeNotifier).

### Estrutura de Pastas (lib/)

```
lib/
├── controllers/
│   └── game_controller.dart  # Lógica central do jogo, estado da batalha
├── data/
│   ├── card_database.dart    # Banco de dados estático das cartas
│   └── monster_database.dart # Banco de dados estático dos monstros
├── models/
│   ├── card_model.dart       # Estrutura de dados de uma Carta e Quiz
│   └── monster_model.dart  # Estrutura de dados de um Monstro
├── screens/
│   ├── battle_screen.dart    # Tela principal da batalha
│   ├── deck_screen.dart      # Tela para visualizar o deck completo
│   ├── lose_screen.dart      # Tela de derrota
│   ├── map_screen.dart       # Tela de seleção de oponente (inicial)
│   ├── reward_screen.dart    # Tela de seleção de recompensa 
│   └── win_screen.dart  
├── widget/
│   ├── card_in_hand_widget.dart # Visual e animação da carta na mão
│   ├── hp_bar.dart           # Barra de HP/Escudo
│   └── quiz_dialog.dart      # O pop-up de perguntas e respostas
└── main.dart                 # Ponto de entrada, inicializa o Provider
```

### Assets

```
assets/
├── images/
│   ├── cards/    # Imagens de fundo das cartas (ex: Minotauro Card.png)
│   ├── monsters/ # Imagens dos oponentes (ex: Minotauro da Tabuada.png)
```

## Próximos Passos e Melhorias

### Erros a Serem Corrigidos (Bugs)

- **DeckScreen em Android:** Corrigir a lógica de exibição na deck_screen.dart (Tela de Cartas Adquiridas), que atualmente não mostra corretamente as cartas da coleção permanente (_acquiredCards), apenas o deck base.

- **Responsividade:** O layout atual pode quebrar em telas menores ou muito grandes (especialmente na BattleScreen). É necessário implementar ajustes para responsividade e evitar Widget Overflows.

### Futuras Adições (Roadmap)

- **Sistema de Login:** Implementar um sistema de autenticação (Firebase Auth, por exemplo) para salvar o progresso do jogador (cartas adquiridas, HP máximo, etc.) na nuvem.

- **Novos Conteúdos:** Adicionar mais monstros, cartas, matérias (Química, História, etc.) e debuffs/buffs.