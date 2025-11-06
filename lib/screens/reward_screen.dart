import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'map_screen.dart';
import '../models/card_model.dart';
import '../widget/card_in_hand_widget.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  // =================================================================
  // INÍCIO DA CORREÇÃO
  // =================================================================

  // MUDANÇA 1: Adicionar 'async' na assinatura da função
  void _selectReward(
    BuildContext context,
    GameController game,
    CardModel card,
  ) async {
    // MUDANÇA 2: Adicionar 'await' para esperar o salvamento no disco
    // antes de continuar a execução.
    await game.addCardToDeck(card);

    // Adiciona a carta à coleção permanente (Linha removida, agora está acima com await)
    // game.addCardToDeck(card);

    // Reseta o estado da batalha
    game.resetGame();

    // MUDANÇA 3: Adicionar verificação de 'mounted' (Boa prática após 'await')
    if (!context.mounted) return;

    // Volta para o MapScreen e remove as telas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ), // Adicionado const
      (route) => false,
    );
  }

  // =================================================================
  // FIM DA CORREÇÃO
  // =================================================================

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final List<CardModel> rewards = game.currentRewards;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
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
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/ui/Card.png'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
                border: Border.all(color: Colors.yellow, width: 2),
              ),
              child: rewards.isEmpty
                  ? const Center(
                      child: Text(
                        "Sem recompensas...",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rewards.map((card) {
                        return SizedBox(
                          height: 250,
                          width: 150,
                          child: CardInHandWidget(
                            card: card,
                            onTap: () {
                              // A chamada aqui permanece a mesma
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
    );
  }
}
