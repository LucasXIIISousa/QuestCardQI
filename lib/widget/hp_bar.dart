import 'package:flutter/material.dart';

class HpBar extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final Color barColor;
  final int currentShield; // Opcional, para o jogador

  const HpBar({
    super.key,
    required this.currentHp,
    required this.maxHp,
    required this.barColor,
    this.currentShield = 0, // Valor padrão é 0
  });

  @override
  Widget build(BuildContext context) {
    double hpPercent = (currentHp > 0) ? (currentHp / maxHp) : 0;
    if (hpPercent < 0) hpPercent = 0;
    if (hpPercent > 1) hpPercent = 1;

    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Stack(
        children: [
          // Barra de HP
          FractionallySizedBox(
            widthFactor: hpPercent,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Barra de Escudo (se existir)
          if (currentShield > 0)
            FractionallySizedBox(
              widthFactor: ((currentHp + currentShield) > maxHp) 
                           ? 1.0 
                           : (currentHp + currentShield) / maxHp,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5), // Cor do escudo
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

          // Texto (HP / MAX HP)
          Center(
            child: Text(
              '$currentHp / $maxHp${currentShield > 0 ? ' (+$currentShield)' : ''}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}