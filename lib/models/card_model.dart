// Define os tipos de efeitos
enum EffectType { damage, heal, shield, applyDebuff, drawCard, stun, applyDot }

// Define os tipos de debuffs
enum DebuffType { vulnerable, weak, poison }

class QuizData {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizData({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}

class CardModel {
  final String id;
  final String name;
  final String subject;
  final String imageAsset;
  final List<QuizData> quizzes;

  final String baseEffectDescription;
  final String bonusEffectDescription;
  final Map<EffectType, dynamic> baseEffect;
  final Map<EffectType, dynamic> bonusEffect;

  final String? acquisitionHint;

  CardModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.imageAsset,
    required this.quizzes,
    required this.baseEffectDescription,
    required this.bonusEffectDescription,
    required this.baseEffect,
    required this.bonusEffect,
    this.acquisitionHint,
  });
}
