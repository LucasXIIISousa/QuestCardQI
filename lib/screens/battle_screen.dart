import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game_controller.dart';
import '../models/card_model.dart';
import '../widget/hp_bar.dart';
import '../widget/card_in_hand_widget.dart';
import '../widget/quiz_dialog.dart';
import 'reward_screen.dart';
import 'lose_screen.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  void _showQuizDialog(
    BuildContext context,
    CardModel card,
    GameController game,
  ) {
    final random = Random();
    if (card.quizzes.isEmpty) {
      print("ERROR: Card ${card.name} has no quizzes!");
      return;
    }
    final QuizData selectedQuiz =
        card.quizzes[random.nextInt(card.quizzes.length)];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return QuizDialog(
          card: card,
          quiz: selectedQuiz,
          onAnswered: (int selectedOptionIndex) {
            game.playCard(
              card,
              selectedOptionIndex,
              selectedQuiz.correctOptionIndex,
            );
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      final currentGameState = context.read<GameController>().gameState;
      final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;

      if (isCurrentRoute) {
        if (currentGameState == GameState.won) {
          game.gameState = GameState.playing;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RewardScreen()),
          );
        } else if (currentGameState == GameState.lost) {
          game.gameState = GameState.playing;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoseScreen()),
          );
        }
      }
    });

    final screenSize = MediaQuery.of(context).size;
    final monsterAreaHeight = screenSize.height * 0.60;
    final playerAreaHeight = screenSize.height * 0.40;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    if (game.currentMonster == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: monsterAreaHeight,
            child: Container(
              padding: EdgeInsets.only(top: statusBarHeight + 10),
              alignment: Alignment.center,
              child: Image.asset(
                game.currentMonster!.imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Text(
                    'Erro: Imagem Monstro',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: statusBarHeight + 15,
            left: 15,
            width: screenSize.width * 0.4,
            child: HpBar(
              currentHp: game.monsterHP,
              maxHp: game.monsterMaxHP,
              barColor: Colors.redAccent,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: playerAreaHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((255 * 0.4).round()),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 220,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          game.hand.length > 3 ? 3 : game.hand.length,
                          (index) {
                            final card = game.hand[index];
                            double angle = 0.0;
                            double verticalOffset = 0.0;
                            double horizontalOffset = 0.0;
                            int itemCount = game.hand.length > 3
                                ? 3
                                : game.hand.length;
                            int centerIndex = (itemCount / 2).floor();

                            if (itemCount > 1) {
                              if (index < centerIndex) {
                                angle = -0.15;
                                verticalOffset = 15.0;
                                horizontalOffset =
                                    (centerIndex - index) *
                                    (screenSize.width * 0.05);
                              } else if (index > centerIndex) {
                                angle = 0.15;
                                verticalOffset = 15.0;
                                horizontalOffset =
                                    -(index - centerIndex) *
                                    (screenSize.width * 0.05);
                              }
                            }

                            return Transform.translate(
                              offset: Offset(horizontalOffset, verticalOffset),
                              child: Transform.rotate(
                                angle: angle,
                                origin: const Offset(0, 90),
                                child: CardInHandWidget(
                                  card: card,
                                  onTap: () {
                                    if (game.isPlayerTurn) {
                                      _showQuizDialog(context, card, game);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: safeAreaBottom + 5),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: safeAreaBottom + 220 + 15,
            right: 15,
            width: screenSize.width * 0.4,
            child: HpBar(
              currentHp: game.playerHP,
              maxHp: game.playerMaxHP,
              barColor: Colors.green,
              currentShield: game.playerShield,
            ),
          ),
          if (game.gameMessage != null && game.gameMessage!.isNotEmpty)
            Positioned(
              bottom: playerAreaHeight - 50,
              left: 20,
              right: 20,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((255 * 0.75).round()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    game.gameMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
