import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../data/card_database.dart'; // Importa todas as cartas
import '../models/card_model.dart';
import '../widget/card_in_collection_widget.dart'; // Importa o novo widget

class DeckScreen extends StatelessWidget {
  const DeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // --- CORREÇÃO AQUI ---
    // Corrigido de 'ownedCounts' para 'ownedCardCounts'
    final Map<String, int> ownedCounts = game.ownedCardCounts;
    // --- FIM DA CORREÇÃO ---

    // O 'allCards' aqui é o suspeito
    final List<CardModel> allCardsInGame = allCards.values.toList();

    // --- LINHA DE DEBUG ADICIONADA ---
    // Isto vai nos dizer quantas cartas o seu app "pensa" que existem
    print("--- DEBUG TELA DE COLEÇÃO ---");
    print("TOTAL DE CARTAS NO allCards: ${allCardsInGame.length}");
    print("IDs das cartas no allCards: ${allCards.keys.toList()}");
    print("-------------------------------");
    // --- FIM DO DEBUG ---

    allCardsInGame.sort((a, b) {
      int subjectCompare = a.subject.compareTo(b.subject);
      if (subjectCompare != 0) {
        return subjectCompare;
      }
      return a.name.compareTo(b.name);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Coleção'),
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas
            childAspectRatio: (130 / 180), // Proporção da carta
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
          ),
          itemCount: allCardsInGame.length,
          itemBuilder: (context, index) {
            final card = allCardsInGame[index];

            final int count = ownedCounts[card.id] ?? 0;
            final bool isOwned = count > 0;

            return CardInCollectionWidget(
              card: card,
              count: count,
              isOwned: isOwned,
            );
          },
        ),
      ),
    );
  }
}
