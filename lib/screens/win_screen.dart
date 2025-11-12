import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'map_screen.dart';
import '../widget/card_in_hand_widget.dart';
import '../models/card_model.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  void _selectReward(BuildContext context, GameController game, CardModel card) {
    game.addCardToDeck(card);
    game.resetGame();
    
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/cards/Card.png'),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: rewards.isEmpty
                    ? const Center(
                        child: Text(
                          "Erro: Sem recompensas para mostrar.",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15.0,
                        runSpacing: 15.0,
                        children: rewards.map((card) {
                          return SizedBox(
                            width: 130,
                            height: 180,
                            child: CardInHandWidget(
                              card: card,
                              onTap: () {
                                _selectReward(context, game, card);
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}