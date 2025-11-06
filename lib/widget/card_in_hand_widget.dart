import 'package:flutter/material.dart';
import '../models/card_model.dart';
// import 'dart:math' as math; // Não necessário se não animar a rotação

class CardInHandWidget extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap; // Função chamada ao tocar na carta

  const CardInHandWidget({super.key, required this.card, required this.onTap});

  @override
  State<CardInHandWidget> createState() => _CardInHandWidgetState();
}

class _CardInHandWidgetState extends State<CardInHandWidget>
    with SingleTickerProviderStateMixin {
  // Controlador e animações para o efeito de "levantar" a carta
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _translateAnimation;

  bool _isHovering =
      false; // Flag para saber se o mouse/dedo está sobre a carta

  @override
  void initState() {
    super.initState();
    // Inicializa o AnimationController
    _controller = AnimationController(
      // Duração curta para a animação parecer responsiva
      duration: const Duration(milliseconds: 150),
      vsync: this, // Necessário para o TickerProvider
    );

    // Define a animação de escala (cresce para 115%)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Define a animação de translação (move 30 pixels para cima)
    _translateAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -30),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera o controller quando o widget é removido
    super.dispose();
  }

  // --- Funções para controlar a animação ---

  // Chamada quando o mouse entra ou o dedo toca
  void _handleInteractionStart() {
    if (!_isHovering) {
      // Evita reiniciar a animação se já estiver ativa
      setState(() {
        _isHovering = true;
      });
      _controller.forward(); // Inicia a animação (escala e sobe)
    }
  }

  // Chamada quando o mouse sai ou o dedo é levantado/cancelado
  void _handleInteractionEnd() {
    // Usamos um bool local para garantir que a reversão só ocorra se o ponteiro realmente saiu
    bool wasHovering = _isHovering;
    setState(() {
      _isHovering = false; // Marca como não hover mais
    });
    if (wasHovering) {
      // Um pequeno delay para evitar flickering se o onTap for muito rápido
      Future.delayed(const Duration(milliseconds: 50), () {
        // Só reverte se o ponteiro/dedo ainda não voltou E o widget ainda existe
        if (mounted && !_isHovering) {
          _controller.reverse(); // Reverte a animação (escala normal e desce)
        }
      });
    }
  }

  // Chamada quando o toque é confirmado (onTap)
  void _handleTap() {
    // Garante que a carta abaixe antes de chamar o onTap
    _controller.reverse().whenCompleteOrCancel(() {
      // Só chama o onTap se o widget ainda estiver montado
      if (mounted) {
        widget.onTap(); // Chama a função original passada (abrir quiz)
      }
    });
    // Garante que o estado _isHovering seja resetado
    if (_isHovering) {
      setState(() {
        _isHovering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder otimiza a reconstrução durante a animação
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Aplica as transformações atuais da animação
        return Transform.translate(
          offset: _translateAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child:
                child, // O child é o widget da carta (MouseRegion/GestureDetector)
          ),
        );
      },
      // O child do AnimatedBuilder (o widget que não muda durante a animação)
      child: MouseRegion(
        // Para Web/Desktop: detecta entrada/saída do mouse
        onEnter: (_) => _handleInteractionStart(),
        onExit: (_) => _handleInteractionEnd(),
        cursor: SystemMouseCursors.click, // Muda o cursor para indicar clicável
        child: GestureDetector(
          // Para Mobile: detecta eventos de toque
          onTapDown: (_) => _handleInteractionStart(), // Dedo tocou
          // onTapUp precisa chamar _handleInteractionEnd para o caso de arrastar e soltar FORA
          onTapUp: (_) => _handleInteractionEnd(),
          onTapCancel: () => _handleInteractionEnd(), // Toque cancelado
          onTap: _handleTap, // Ação principal ao tocar e soltar DENTRO
          // --- O VISUAL DA CARTA (Container com Stack e Imagem de Fundo) ---
          child: Container(
            width: 130, // Largura da carta
            height: 180, // Altura da carta
            // A margem agora é controlada pela BattleScreen com Transform.translate
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: !_isHovering
                  ? [
                      // Sombra padrão
                      BoxShadow(
                        // CORRIGIDO: Usa withAlpha
                        color: Colors.black.withAlpha((255 * 0.7).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [
                      // Sombra maior quando levantada
                      BoxShadow(
                        // CORRIGIDO: Usa withAlpha
                        color: Colors.black.withAlpha((255 * 0.9).round()),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            // ClipRRect para cortar a imagem com as bordas arredondadas
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                // Empilha imagem, overlay e textos
                fit: StackFit.expand, // Faz o Stack preencher o ClipRRect
                children: [
                  // 1. Imagem de Fundo da Carta
                  Positioned.fill(
                    child: Image.asset(
                      widget.card.imageAsset, // Caminho da imagem
                      fit: BoxFit.cover, // Cobre todo o espaço
                      // Widget mostrado se a imagem falhar
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepOrange[900], // Cor sólida no erro
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              // CORRIGIDO: Usa withAlpha
                              color: Colors.white.withAlpha(
                                (255 * 0.6).round(),
                              ),
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 2. Overlay Gradiente (para legibilidade)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            // CORRIGIDO: Usa withAlpha
                            Colors.black.withAlpha(
                              (255 * 0.1).round(),
                            ), // Menos opaco em cima
                            Colors.black.withAlpha(
                              (255 * 0.6).round(),
                            ), // Mais opaco embaixo
                          ],
                          stops: const [
                            0.0,
                            0.9,
                          ], // Gradiente mais forte na base
                        ),
                      ),
                    ),
                  ),

                  // 3. Conteúdo da Carta (Textos)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Nome em cima, resto embaixo
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, // Estica a tag de assunto
                      children: [
                        // Nome da Carta
                        Text(
                          widget.card.name,
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

                        // Parte Inferior (Assunto e Efeitos)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min, // Encolhe para caber
                          children: [
                            // Assunto (Tag)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                // CORRIGIDO: Usa withAlpha (e null check '??')
                                color:
                                    Colors.deepOrange[800]?.withAlpha(
                                      (255 * 0.8).round(),
                                    ) ??
                                    Colors.deepOrange.withAlpha(
                                      (255 * 0.8).round(),
                                    ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.card.subject,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Efeitos (Acerto e Erro)
                            Text(
                              "✓: ${widget.card.bonusEffectDescription}",
                              style: const TextStyle(
                                color: Colors.lightGreenAccent, // Cor mais viva
                                fontSize: 9.5, // Levemente maior
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 2),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "✗: ${widget.card.baseEffectDescription}",
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 2),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ], // Fim dos filhos do Stack
              ),
            ),
          ),
        ),
      ),
    );
  }
}
