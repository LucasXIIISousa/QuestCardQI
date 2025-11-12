import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'map_screen.dart';
import '../widget/card_in_hand_widget.dart';
import '../models/card_model.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  void _selectReward(BuildContext context, GameController game, CardModel card) async {
    await game.addCardToDeck(card);
    game.resetGame();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final List<CardModel> rewards = game.currentRewards;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VITÓRIA!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Escolha sua Recompensa!',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 30),
              // Container ajustado para acomodar 3 cartas lado a lado de forma responsiva
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/cards/Card.png'),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                // altura suficiente para as cartas e espaço extra
                constraints: const BoxConstraints(minHeight: 220, maxHeight: 400),
                child: rewards.isEmpty
                    ? const Center(
                        child: Text(
                          "Sem recompensas...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // calcula largura disponível considerando padding interno
                          final double availableWidth = constraints.maxWidth - 24; // padding internal
                          // queremos mostrar 3 cartas lado a lado; aplica spacing de 15 entre elas
                          final double spacing = 15.0;
                          double cardWidth = (availableWidth - (2 * spacing)) / 3;
                          // limita a largura máxima da carta para manter bom aspecto
                          if (cardWidth > 150) cardWidth = 150;
                          // largura mínima razoável
                          if (cardWidth < 90) cardWidth = 90;

                          // se ainda assim não couber bem, permitimos scroll horizontal
                          final bool needScroll = (cardWidth * rewards.length + spacing * (rewards.length - 1)) > availableWidth;

                          Widget content = Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: rewards.map((card) {
                              return SizedBox(
                                width: cardWidth,
                                height: 180,
                                child: CardInHandWidget(
                                  card: card,
                                  onTap: () {
                                    _selectReward(context, game, card);
                                  },
                                ),
                              );
                            }).toList(),
                          );

                          if (needScroll) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: rewards.map((card) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: spacing),
                                      child: SizedBox(
                                        width: cardWidth,
                                        height: 180,
                                        child: CardInHandWidget(
                                          card: card,
                                          onTap: () {
                                            _selectReward(context, game, card);
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: content,
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
