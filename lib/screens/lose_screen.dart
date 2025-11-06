import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'map_screen.dart';
import 'battle_screen.dart';

class LoseScreen extends StatelessWidget {
  const LoseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameController>();
    // Guarda a referência do monstro atual antes que resetGame() limpe
    final monsterToRetry = game.currentMonster;

    return Scaffold(
      backgroundColor: Colors.red[900]?.withAlpha(
        200,
      ), // Fundo vermelho escuro semi-transparente
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'DERROTA',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Você foi derrotado. Não desista!',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 60),

            // Botão "Tentar Novamente"
            ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              label: const Text(
                'Tentar Novamente',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                if (monsterToRetry != null) {
                  // Reinicia o jogo COM O MESMO MONSTRO
                  game.startGame(monsterToRetry);
                  // Substitui a LoseScreen pela BattleScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BattleScreen(),
                    ),
                  );
                } else {
                  // Fallback: Se algo der errado, volta pro mapa
                  game.resetGame();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // Botão "Sair para o Mapa"
            OutlinedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text(
                'Sair para o Mapa',
                style: TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Reseta completamente o estado do jogo
                game.resetGame();
                // Volta para o MapScreen, removendo LoseScreen e BattleScreen da pilha
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
