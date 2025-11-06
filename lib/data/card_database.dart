import '../models/card_model.dart';

final Map<String, CardModel> allCards = {
  // --- CARTAS BÁSICAS (do baralho inicial) ---
  'basic_sum': CardModel(
    id: 'basic_sum',
    name: 'Soma Simples',
    subject: 'Matemática',
    imageAsset: 'assets/images/cards/Minotauro Card.png',
    baseEffectDescription: 'Causa 5 de dano.',
    bonusEffectDescription: 'Causa 15 de dano.',
    baseEffect: {EffectType.damage: 5},
    bonusEffect: {EffectType.damage: 15},
    // Cartas básicas não precisam de dica
    quizzes: [
      QuizData(
        question: 'Quanto é 7 + 8?',
        options: ['13', '14', '15', '16'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Quanto é 9 + 5?',
        options: ['14', '13', '15'],
        correctOptionIndex: 0,
      ),
    ],
  ),
  'basic_capital': CardModel(
    id: 'basic_capital',
    name: 'Capital Fácil',
    subject: 'Geografia',
    imageAsset: 'assets/images/cards/Cartografo Card.png',
    baseEffectDescription: 'Ganhe 5 de Escudo.',
    bonusEffectDescription: 'Ganhe 15 de Escudo.',
    baseEffect: {EffectType.shield: 5},
    bonusEffect: {EffectType.shield: 15},
    // Cartas básicas não precisam de dica
    quizzes: [
      QuizData(
        question: 'Qual a capital da França?',
        options: ['Londres', 'Berlim', 'Paris', 'Madri'],
        correctOptionIndex: 2,
      ),
    ],
  ),

  // --- NOVAS CARTAS DE MATEMÁTICA (DANO) ---
  'math_mult': CardModel(
    id: 'math_mult',
    name: 'Multiplicar',
    subject: 'Matemática',
    imageAsset: 'assets/images/cards/Minotauro Card.png',
    baseEffectDescription: 'Causa 8 de dano.',
    bonusEffectDescription: 'Causa 25 de dano.',
    baseEffect: {EffectType.damage: 8},
    bonusEffect: {EffectType.damage: 25},
    // DICA ADICIONADA
    acquisitionHint: 'Derrote o Minotauro da Tabuada.',
    quizzes: [
      QuizData(
        question: 'Quanto é 6 x 7?',
        options: ['42', '48', '36'],
        correctOptionIndex: 0,
      ),
      QuizData(
        question: 'Quanto é 8 x 9?',
        options: ['64', '72', '81'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 12 x 5?',
        options: ['50', '65', '60'],
        correctOptionIndex: 2,
      ),
    ],
  ),
  'math_div': CardModel(
    id: 'math_div',
    name: 'Dividir',
    subject: 'Matemática',
    imageAsset: 'assets/images/cards/Minotauro Card.png',
    baseEffectDescription: 'Causa 10 de dano.',
    bonusEffectDescription: 'Causa 30 de dano.',
    baseEffect: {EffectType.damage: 10},
    bonusEffect: {EffectType.damage: 30},
    // DICA ADICIONADA
    acquisitionHint: 'Derrote o Minotauro da Tabuada.',
    quizzes: [
      QuizData(
        question: 'Quanto é 100 / 4?',
        options: ['20', '30', '25'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Quanto é 81 / 9?',
        options: ['9', '8', '7'],
        correctOptionIndex: 0,
      ),
      QuizData(
        question: 'Quanto é 42 / 6?',
        options: ['8', '7', '6'],
        correctOptionIndex: 1,
      ),
    ],
  ),

  // --- NOVAS CARTAS DE FÍSICA (DANO E ESCUDO) ---
  'phys_forca': CardModel(
    id: 'phys_forca',
    name: 'Força Resultante',
    subject: 'Física',
    imageAsset: 'assets/images/cards/Dr.Card.png',
    baseEffectDescription: 'Causa 5 de dano.',
    bonusEffectDescription: 'Causa 10 de dano e ganhe 15 de Escudo.',
    baseEffect: {EffectType.damage: 5},
    bonusEffect: {EffectType.damage: 10, EffectType.shield: 15},
    // DICA ADICIONADA
    acquisitionHint: 'Derrote o Dr. Físico.',
    quizzes: [
      QuizData(
        question: 'Qual a fórmula da Força (Segunda Lei de Newton)?',
        options: ['F = m/a', 'F = m * a', 'F = m * v'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'O que mede a unidade "Newton"?',
        options: ['Massa', 'Velocidade', 'Força'],
        correctOptionIndex: 2,
      ),
    ],
  ),
  'tesla': CardModel(
    id: 'tesla',
    name: 'Nikola Tesla',
    subject: 'Física',
    imageAsset: 'assets/images/cards/Dr.Card.png',
    baseEffectDescription: 'Causa 10 de dano.',
    bonusEffectDescription: 'Causa 15 de dano e aplica 2 de Vulnerável.',
    baseEffect: {EffectType.damage: 10},
    bonusEffect: {
      EffectType.damage: 15,
      EffectType.applyDebuff: {'type': DebuffType.vulnerable, 'duration': 2},
    },
    acquisitionHint: 'Derrote o Dr. Físico.',
    quizzes: [
      QuizData(
        question: 'Qual corrente Tesla defendeu contra Edison?',
        options: ['Contínua (DC)', 'Alternada (AC)', 'Iônica'],
        correctOptionIndex: 1,
      ),
    ],
  ),

  // --- NOVAS CARTAS DE GEOGRAFIA (DANO CONTÍNUO) ---
  'geo_capital': CardModel(
    id: 'geo_capital',
    name: 'Capital Mundial',
    subject: 'Geografia',
    imageAsset: 'assets/images/cards/Cartografo Card.png',
    baseEffectDescription: 'Causa 2 de dano.',
    bonusEffectDescription: 'Aplica 5 de Dano Contínuo por 3 turnos.',
    baseEffect: {EffectType.damage: 2},
    bonusEffect: {
      EffectType.applyDot: {'duration': 3, 'damage': 5},
    },
    acquisitionHint: 'Derrote o Cartomundo.',
    quizzes: [
      QuizData(
        question: 'Qual a capital do Japão?',
        options: ['Pequim', 'Seul', 'Tóquio'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital da Austrália?',
        options: ['Sydney', 'Canberra', 'Melbourne'],
        correctOptionIndex: 1,
      ),
    ],
  ),
};
