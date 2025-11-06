import '../models/card_model.dart';
import '../models/monster_model.dart';

final Map<String, MonsterModel> allMonsters = {
  'minotaur': MonsterModel(
    id: 'minotaur',
    name: 'Minotauro da Tabuada',
    maxHP: 100,
    imageAsset: 'assets/images/monsters/Minotauro da Tabuada.png',
    attackPattern: [
      {EffectType.damage: 10},
    ],
    rewardCardPool: ['math_mult', 'math_div', 'basic_sum'],
  ),

  'dr_fisico': MonsterModel(
    id: 'dr_fisico',
    name: 'Dr. Físico',
    maxHP: 150,
    imageAsset: 'assets/images/monsters/Dr.Fisico.png',
    attackPattern: [
      {EffectType.damage: 10},
      {EffectType.shield: 15},
    ],
    rewardCardPool: ['phys_forca', 'tesla'],
  ),

  'cartomundo': MonsterModel(
    id: 'cartomundo',
    name: 'Cartomundo',
    maxHP: 120,
    imageAsset: 'assets/images/monsters/Cartomundo.png',
    attackPattern: [
      {EffectType.damage: 5},
      {
        EffectType.applyDot: {'duration': 2, 'damage': 5},
      },
    ],
    rewardCardPool: ['geo_capital', 'basic_capital'],
  ),
};
