import 'card_model.dart';

class MonsterModel {
  final String id;
  final String name;
  final int maxHP;
  final String imageAsset;
  final List<Map<EffectType, dynamic>> attackPattern;

  final List<String> rewardCardPool;

  MonsterModel({
    required this.id,
    required this.name,
    required this.maxHP,
    required this.imageAsset,
    required this.attackPattern,
    required this.rewardCardPool,
  });
}
