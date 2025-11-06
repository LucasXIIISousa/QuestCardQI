import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../data/monster_database.dart';
import 'battle_screen.dart';
import 'deck_screen.dart';
import '../models/monster_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Função helper para iniciar a batalha e navegar
  void _startBattle(BuildContext context, MonsterModel monster) {
    final game = context.read<GameController>();
    game.startGame(monster);
    // Navega para a BattleScreen, substituindo a MapScreen (opcional, mas evita voltar para o mapa vazio)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BattleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MonsterModel? minotaur = allMonsters['minotaur'];
    final MonsterModel? drFisico = allMonsters['dr_fisico'];
    final MonsterModel? cartomundo = allMonsters['cartomundo'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa dos Desafios'),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.style),
            tooltip: 'Ver Minhas Cartas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeckScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[850],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Escolha seu Oponente!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              if (minotaur != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.orange[800],
                  ),
                  onPressed: () => _startBattle(context, minotaur),
                  child: Text(
                    minotaur.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 25),

              // Botão Dr. Físico
              if (drFisico != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue[700],
                  ),
                  onPressed: () => _startBattle(context, drFisico),
                  child: Text(
                    drFisico.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 25),

              // Botão Cartomundo
              if (cartomundo != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () => _startBattle(context, cartomundo),
                  child: Text(
                    cartomundo.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),

              // Adicione mais monstros aqui V
            ],
          ),
        ),
      ),
    );
  }
}
