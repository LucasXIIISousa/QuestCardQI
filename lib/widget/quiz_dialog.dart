import 'package:flutter/material.dart';
import '../models/card_model.dart';

class QuizDialog extends StatefulWidget {
  final CardModel card;
  final QuizData quiz;
  final Function(int) onAnswered;

  const QuizDialog({
    super.key,
    required this.card,
    required this.quiz,
    required this.onAnswered,
  });

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  int? _selectedOptionIndex;

  void _handleOptionTap(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        widget.onAnswered(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final horizontalPadding = screenSize.width * 0.10;
    // Margem vertical, pode ser um pouco maior.
    final verticalPadding = screenSize.height * 0.15;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      // Aplica o novo padding (margens externas)
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          // Padding interno (para o texto dentro do widget)
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cards/Card.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.card.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.quiz.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.quiz.options.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String optionText = entry.value;
                    bool isSelected = (_selectedOptionIndex == idx);

                    return GestureDetector(
                      onTap: () => _handleOptionTap(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.amber.withAlpha(50)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.amberAccent.withAlpha(150),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                ]
                              : null,
                        ),
                        transformAlignment: Alignment.center,
                        transform: isSelected
                            ? (Matrix4.identity()..scale(1.10))
                            : Matrix4.identity(),
                        child: Text(
                          optionText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.amber[600]!
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSelected ? 19 : 18,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
