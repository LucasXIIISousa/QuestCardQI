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

            // 2. Overlay Gradiente
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha((255 * 0.1).round()),
                    Colors.black.withAlpha((255 * 0.6).round()),
                  ],
                  stops: const [0.0, 0.9],
                ),
              ),
            ),

            // 3. Conteúdo da Carta (Textos)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        // Corrigido para "Acerto:" para evitar erros de fonte na Web
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
                        // Corrigido para "Erro:"
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

    return Stack(
      clipBehavior: Clip.none, // Permite o ícone sair para fora
      children: [
        // 1. O VISUAL DA CARTA (SEMPRE PRESENTE)
        // Se não for "owned", aplicamos o filtro cinza.
        if (!isOwned)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: cardVisual,
            ),
          )
        else
          // Se for "owned", mostramos a carta normal.
          cardVisual,

        // 2. OVERLAY DE "NÃO ADQUIRIDA" (SÓ APARECE SE NÃO FOR "OWNED")
        if (!isOwned)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                  // --- CORREÇÃO AQUI ---
                  // Trocado de Colors.black.withOpacity(0.6)
                  color: Colors.black.withAlpha(153),
                  // --- FIM DA CORREÇÃO ---
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                        size: 40,
                      ),
                      if (card.acquisitionHint != null) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            card.acquisitionHint!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
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
