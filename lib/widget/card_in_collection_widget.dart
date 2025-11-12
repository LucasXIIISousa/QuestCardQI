import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'dart:ui'; // Para o ImageFilter (blur)

class CardInCollectionWidget extends StatelessWidget {
  final CardModel card;
  final int count; // Quantidade que o jogador possui
  final bool isOwned; // Se o jogador possui (count > 0)

  const CardInCollectionWidget({
    super.key,
    required this.card,
    required this.count,
    required this.isOwned,
  });

  Color _colorForSubject(String s) {
    switch (s.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return Colors.deepOrange;
      case 'geografia':
        return Colors.teal;
      case 'física':
      case 'fisica':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget base com o visual da carta
    Widget cardVisual = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.7).round()),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Imagem de Fundo
            Image.asset(
              card.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.deepOrange[900],
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

            // 2. Overlay Gradiente (escurece o fundo para garantir legibilidade do texto)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha((255 * 0.15).round()),
                    Colors.black.withAlpha((255 * 0.65).round()),
                  ],
                  stops: const [0.0, 0.9],
                ),
              ),
            ),

            // 3. Faixa de assunto (pequena, ajuda a diferenciar)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _colorForSubject(card.subject),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  card.subject,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 4. Conteúdo da Carta (Textos)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nome no topo
                  Text(
                    card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Efeitos/descrições na parte inferior
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[800]?.withAlpha(
                            (255 * 0.8).round(),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          card.subject,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Acerto: ${card.bonusEffectDescription}",
                        style: const TextStyle(
                          color: Colors.lightGreenAccent,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Erro: ${card.baseEffectDescription}",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Container externo adicionando borda se owned
    Widget withBorder = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isOwned ? Border.all(color: Colors.yellowAccent, width: 3) : null,
      ),
      child: cardVisual,
    );

    return Stack(
      clipBehavior: Clip.none, // Permite o ícone sair para fora
      children: [
        // 1. Conteúdo base (com borda se owned)
        withBorder,

        // 2. OVERLAY DE "NÃO ADQUIRIDA" (transparente — NÃO bloqueia os textos)
        if (!isOwned)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  // sem o BackdropFilter forte; apenas uma camada semitransparente
                  Container(
                    color: Colors.black.withAlpha(80), // leve transparência - mantém textos legíveis
                  ),

                  // Cadeado discreto no canto superior direito
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),

                  // Dica de aquisição na base (se houver) — pequena e não cobre os textos principais
                  if (card.acquisitionHint != null)
                    Positioned(
                      left: 6,
                      right: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          card.acquisitionHint!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

        // 3. CONTAGEM (SÓ APARECE SE FOR "OWNED")
        if (isOwned && count > 0)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              child: Center(
                child: Text(
                  'x$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
