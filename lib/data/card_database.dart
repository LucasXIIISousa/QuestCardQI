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
      QuizData(
        question: 'Quanto é 12 + 18?',
        options: ['28', '30', '32', '26'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 25 + 17?',
        options: ['40', '42', '44', '38'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 33 + 29?',
        options: ['60', '62', '64', '58'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 6 + 9?',
        options: ['14', '15', '16', '17'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 11 + 14?',
        options: ['23', '24', '25', '26'],
        correctOptionIndex: 2,
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
      QuizData(
        question: 'Qual a capital do Brasil?',
        options: ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital da Itália?',
        options: ['Roma', 'Milão', 'Veneza', 'Nápoles'],
        correctOptionIndex: 0,
      ),
      QuizData(
        question: 'Qual a capital da Espanha?',
        options: ['Barcelona', 'Madri', 'Sevilha', 'Valência'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Qual a capital de Portugal?',
        options: ['Porto', 'Coimbra', 'Lisboa', 'Braga'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital da Argentina?',
        options: ['Buenos Aires', 'Córdoba', 'Rosário', 'Mendoza'],
        correctOptionIndex: 0,
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
      QuizData(
        question: 'Quanto é 7 x 8?',
        options: ['54', '56', '58', '60'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 9 x 6?',
        options: ['52', '54', '56', '58'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 11 x 11?',
        options: ['111', '121', '131', '141'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 15 x 4?',
        options: ['55', '60', '65', '70'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 3 x 13?',
        options: ['36', '39', '42', '45'],
        correctOptionIndex: 1,
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
      QuizData(
        question: 'Quanto é 144 / 12?',
        options: ['11', '12', '13', '14'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 63 / 7?',
        options: ['7', '8', '9', '10'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Quanto é 56 / 8?',
        options: ['6', '7', '8', '9'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Quanto é 72 / 9?',
        options: ['6', '7', '8', '9'],
        correctOptionIndex: 2,
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
      QuizData(
        question: 'Qual a aceleração da gravidade na Terra (aprox)?',
        options: ['8 m/s²', '9,8 m/s²', '10,5 m/s²', '12 m/s²'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Se massa = 10kg e aceleração = 5m/s², qual a força?',
        options: ['50 N', '15 N', '2 N', '100 N'],
        correctOptionIndex: 0,
      ),
      QuizData(
        question: 'Qual lei descreve inércia?',
        options: ['2ª Lei de Newton', '3ª Lei de Newton', '1ª Lei de Newton'],
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
      QuizData(
        question: 'Em que ano Nikola Tesla nasceu?',
        options: ['1846', '1856', '1866', '1876'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Qual era a nacionalidade de Tesla?',
        options: ['Americano', 'Sérvio', 'Russo', 'Alemão'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Tesla trabalhou brevemente para qual inventor?',
        options: ['Graham Bell', 'Thomas Edison', 'Henry Ford'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Qual unidade física leva o nome de Tesla?',
        options: ['Corrente elétrica', 'Campo magnético', 'Tensão', 'Potência'],
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
      QuizData(
        question: 'Qual a capital do Canadá?',
        options: ['Toronto', 'Vancouver', 'Ottawa', 'Montreal'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital da Alemanha?',
        options: ['Munique', 'Hamburgo', 'Berlim', 'Frankfurt'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital da Índia?',
        options: ['Mumbai', 'Calcutá', 'Nova Délhi', 'Bangalore'],
        correctOptionIndex: 2,
      ),
      QuizData(
        question: 'Qual a capital do Egito?',
        options: ['Alexandria', 'Cairo', 'Luxor', 'Gizé'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Qual a capital da Rússia?',
        options: ['São Petersburgo', 'Moscou', 'Kiev', 'Volgograd'],
        correctOptionIndex: 1,
      ),
      QuizData(
        question: 'Qual a capital da China?',
        options: ['Xangai', 'Hong Kong', 'Pequim', 'Guangzhou'],
        correctOptionIndex: 2,
      ),
    ],
  ),
};
