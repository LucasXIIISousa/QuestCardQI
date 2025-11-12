import 'dart:convert';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';
import '../models/monster_model.dart';
import '../data/card_database.dart';
import '../data/monster_database.dart';

enum GameState { playing, won, lost }

// Instância global de Random para garantir aleatoriedade real
final _random = Random();

class GameController with ChangeNotifier, WidgetsBindingObserver {
  final SharedPreferences _prefs;
  static const String _collectionKey = 'ownedCardIds';
  static const String _gameStateKey = 'savedGameState';

  GameState gameState = GameState.playing;

  MonsterModel? currentMonster;
  int playerHP = 100;
  int playerMaxHP = 100;
  int playerShield = 0;
  int monsterHP = 1;
  int monsterMaxHP = 1;
  Map<DebuffType, dynamic> monsterDebuffs = {};

  final List<String> _baseDeckIds = [
    'basic_sum',
    'basic_sum',
    'basic_sum',
    'basic_sum',
    'basic_sum',
    'basic_capital',
    'basic_capital',
    'basic_capital',
    'basic_capital',
    'basic_capital',
  ];

  List<String> _ownedCardIds = [];

  List<CardModel> playerDeck = [];
  List<CardModel> hand = [];
  List<CardModel> discardPile = [];
  List<CardModel> currentRewards = [];

  bool isPlayerTurn = true;
  String? gameMessage;

  List<CardModel> get fullDeckCollection {
    List<CardModel> deck = [];
    for (String cardId in _ownedCardIds) {
      if (allCards.containsKey(cardId)) {
        deck.add(allCards[cardId]!);
      }
    }
    return deck;
  }

  Map<String, int> get ownedCardCounts {
    final Map<String, int> counts = {};
    for (String cardId in _ownedCardIds) {
      counts[cardId] = (counts[cardId] ?? 0) + 1;
    }
    return counts;
  }

  GameController({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences {
    _loadCollection();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App foi minimizado ou está sendo pausado
      _saveGameState();
    } else if (state == AppLifecycleState.resumed) {
      // App foi retomado
      _loadGameState();
    }
  }

  void _loadCollection() {
    final List<String>? savedCollection = _prefs.getStringList(_collectionKey);

    if (savedCollection != null && savedCollection.isNotEmpty) {
      _ownedCardIds = savedCollection;
      print("Coleção carregada: ${_ownedCardIds.length} cartas.");
    } else {
      _ownedCardIds = List.from(_baseDeckIds);
      print("Nenhuma coleção salva. Iniciando com deck base.");
      _saveCollection();
    }
    notifyListeners();
  }

  Future<void> _saveCollection() async {
    await _prefs.setStringList(_collectionKey, _ownedCardIds);
    print("Coleção salva com ${_ownedCardIds.length} cartas.");
  }

  // Salva o estado atual da batalha
  Future<void> _saveGameState() async {
    if (gameState != GameState.playing || currentMonster == null) {
      // Não há batalha ativa, limpa o estado salvo
      await _prefs.remove(_gameStateKey);
      return;
    }

    final stateData = {
      'monsterId': currentMonster!.id,
      'playerHP': playerHP,
      'playerMaxHP': playerMaxHP,
      'playerShield': playerShield,
      'monsterHP': monsterHP,
      'monsterMaxHP': monsterMaxHP,
      'isPlayerTurn': isPlayerTurn,
      'handCardIds': hand.map((card) => card.id).toList(),
      'deckCardIds': playerDeck.map((card) => card.id).toList(),
      'discardCardIds': discardPile.map((card) => card.id).toList(),
    };

    await _prefs.setString(_gameStateKey, jsonEncode(stateData));
    print("Estado do jogo salvo!");
  }

  // Carrega o estado da batalha
  void _loadGameState() {
    final stateJson = _prefs.getString(_gameStateKey);
    if (stateJson == null || stateJson.isEmpty) {
      return;
    }

    try {
      final stateData = jsonDecode(stateJson) as Map<String, dynamic>;
      
      // Restaura o monstro
      final monsterId = stateData['monsterId'] as String?;
      if (monsterId != null && allMonsters.containsKey(monsterId)) {
        currentMonster = allMonsters[monsterId];
      } else {
        // Monstro não encontrado, limpa o estado
        _prefs.remove(_gameStateKey);
        return;
      }

      // Restaura stats do jogador
      playerHP = stateData['playerHP'] as int? ?? 100;
      playerMaxHP = stateData['playerMaxHP'] as int? ?? 100;
      playerShield = stateData['playerShield'] as int? ?? 0;
      
      // Restaura stats do monstro
      monsterHP = stateData['monsterHP'] as int? ?? currentMonster!.maxHP;
      monsterMaxHP = stateData['monsterMaxHP'] as int? ?? currentMonster!.maxHP;
      
      isPlayerTurn = stateData['isPlayerTurn'] as bool? ?? true;
      
      // Restaura cartas
      hand.clear();
      playerDeck.clear();
      discardPile.clear();

      final handIds = (stateData['handCardIds'] as List?)?.cast<String>() ?? [];
      final deckIds = (stateData['deckCardIds'] as List?)?.cast<String>() ?? [];
      final discardIds = (stateData['discardCardIds'] as List?)?.cast<String>() ?? [];

      for (String cardId in handIds) {
        if (allCards.containsKey(cardId)) {
          hand.add(allCards[cardId]!);
        }
      }

      for (String cardId in deckIds) {
        if (allCards.containsKey(cardId)) {
          playerDeck.add(allCards[cardId]!);
        }
      }

      for (String cardId in discardIds) {
        if (allCards.containsKey(cardId)) {
          discardPile.add(allCards[cardId]!);
        }
      }

      gameState = GameState.playing;
      gameMessage = "Batalha restaurada!";
      
      print("Estado do jogo carregado com sucesso!");
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar estado do jogo: $e");
      _prefs.remove(_gameStateKey);
    }
  }

  void startGame(MonsterModel monster) {
    gameState = GameState.playing;
    gameMessage = "Batalha iniciada!";
    currentMonster = monster;
    monsterHP = monster.maxHP;
    monsterMaxHP = monster.maxHP;
    monsterDebuffs.clear();
    playerHP = 100;
    playerMaxHP = 100;
    playerShield = 0;
    isPlayerTurn = true;

    playerDeck.clear();
    // Monta o deck de batalha a partir da coleção JÁ CARREGADA
    for (String cardId in _ownedCardIds) {
      if (allCards.containsKey(cardId)) {
        playerDeck.add(allCards[cardId]!);
      }
    }
    playerDeck.shuffle(_random);

    discardPile.clear();
    hand.clear();
    drawCards(5);
    notifyListeners();
  }

  void drawCards(int amount) {
    for (int i = 0; i < amount; i++) {
      if (playerDeck.isEmpty) {
        if (discardPile.isEmpty) return;
        playerDeck.addAll(discardPile);
        playerDeck.shuffle(_random);
        discardPile.clear();
      }
      if (playerDeck.isNotEmpty) {
        hand.add(playerDeck.removeLast());
      }
    }
    notifyListeners();
  }

  void playCard(
    CardModel card,
    int selectedOptionIndex,
    int correctOptionIndex,
  ) {
    if (!isPlayerTurn || gameState != GameState.playing) return;

    hand.remove(card);
    discardPile.add(card);

    bool isCorrect = (selectedOptionIndex == correctOptionIndex);

    if (isCorrect) {
      gameMessage = "Correto! ${card.bonusEffectDescription}";
      _applyEffect(card.bonusEffect);
    } else {
      gameMessage = "Errado! ${card.baseEffectDescription}";
      _applyEffect(card.baseEffect);
    }

    if (monsterHP <= 0 && gameState == GameState.playing) {
      monsterHP = 0;
      gameMessage = "Você venceu!";
      gameState = GameState.won;
      _generateRewards();
      notifyListeners();
      return;
    }

    if (gameState == GameState.playing) {
      endPlayerTurn();
    }
  }

  void _applyEffect(Map<EffectType, dynamic> effect) {
    if (effect.containsKey(EffectType.damage)) {
      int damage = effect[EffectType.damage];
      if (monsterDebuffs.containsKey(DebuffType.vulnerable)) {
        damage = (damage * 1.5).round();
      }
      monsterHP -= damage;
    }

    if (effect.containsKey(EffectType.shield)) {
      playerShield += effect[EffectType.shield] as int;
    }

    if (effect.containsKey(EffectType.heal)) {
      playerHP += effect[EffectType.heal] as int;
      if (playerHP > playerMaxHP) playerHP = playerMaxHP;
    }

    if (effect.containsKey(EffectType.drawCard)) {
      drawCards(effect[EffectType.drawCard] as int);
    }

    if (effect.containsKey(EffectType.applyDebuff)) {
      var debuffInfo = effect[EffectType.applyDebuff];
      DebuffType type = debuffInfo['type'];
      int duration = debuffInfo['duration'];
      monsterDebuffs[type] = (monsterDebuffs[type] ?? 0) + duration;
    }

    if (effect.containsKey(EffectType.applyDot)) {
      var dotInfo = effect[EffectType.applyDot];
      int duration = dotInfo['duration'];
      int damage = dotInfo['damage'];
      DebuffType type = DebuffType.poison;
      int existingDuration = (monsterDebuffs[type] is Map)
          ? (monsterDebuffs[type]['duration'] ?? 0)
          : 0;
      monsterDebuffs[type] = {
        'duration': existingDuration + duration,
        'damage': damage,
      };
    }

    if (monsterHP < 0) monsterHP = 0;
    notifyListeners();
  }

  void endPlayerTurn() {
    isPlayerTurn = false;
    notifyListeners();

    if (monsterDebuffs.containsKey(DebuffType.poison)) {
      if (monsterDebuffs[DebuffType.poison] is Map) {
        int dotDamage = monsterDebuffs[DebuffType.poison]!['damage'];
        monsterHP -= dotDamage;
        gameMessage = "O monstro sofreu $dotDamage de dano contínuo.";
        notifyListeners();

        if (monsterHP <= 0 && gameState == GameState.playing) {
          monsterHP = 0;
          gameMessage = "Você venceu!";
          gameState = GameState.won;
          _generateRewards();
          notifyListeners();
          return;
        }
      }
    }

    Map<DebuffType, dynamic> newDebuffs = {};
    monsterDebuffs.forEach((key, value) {
      if (value is Map) {
        if (value['duration'] > 1) {
          newDebuffs[key] = {
            'duration': value['duration'] - 1,
            'damage': value['damage'],
          };
        }
      } else if (value is int) {
        if (value > 1) {
          newDebuffs[key] = value - 1;
        }
      }
    });
    monsterDebuffs = newDebuffs;

    if (gameState == GameState.playing) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && gameState == GameState.playing) {
          _monsterTurn();
        }
      });
    }
  }

  void _monsterTurn() {
    if (gameState != GameState.playing || currentMonster == null) return;

    // Usa a instância global de Random
    final attack = currentMonster!
        .attackPattern[_random.nextInt(currentMonster!.attackPattern.length)];

    int damage = 0;
    String monsterActionMessage =
        "O ${currentMonster!.name} usa uma habilidade!";

    if (attack.containsKey(EffectType.damage)) {
      damage = attack[EffectType.damage];
    }

    if (damage > 0) {
      if (playerShield > 0) {
        if (playerShield >= damage) {
          playerShield -= damage;
          damage = 0;
        } else {
          damage -= playerShield;
          playerShield = 0;
          playerHP -= damage;
        }
      } else {
        playerHP -= damage;
      }
      monsterActionMessage =
          "O ${currentMonster!.name} ataca e causa ${attack[EffectType.damage]} de dano!";
    }

    gameMessage = monsterActionMessage;
    notifyListeners();

    if (playerHP <= 0 && gameState == GameState.playing) {
      playerHP = 0;
      gameMessage = "Você foi derrotado!";
      gameState = GameState.lost;
      notifyListeners();
      return;
    }

    if (gameState == GameState.playing) {
      isPlayerTurn = true;
      drawCards(1);
    }
  }

  void _generateRewards() {
    currentRewards.clear();
    if (currentMonster == null) return;

    List<String> pool = List.from(currentMonster!.rewardCardPool);
    pool.shuffle(_random);

    int count = 0;
    for (String cardId in pool) {
      if (count >= 3) break;
      if (allCards.containsKey(cardId)) {
        currentRewards.add(allCards[cardId]!);
        count++;
      }
    }
  }

  // =================================================================
  // INÍCIO DA CORREÇÃO
  // =================================================================

  // MUDANÇA 1: Adicionar 'async'
  Future<void> addCardToDeck(CardModel card) async {
    _ownedCardIds.add(card.id);
    print("Carta ${card.name} adicionada à coleção!");

    // MUDANÇA 2: Adicionar 'await' para garantir que o salvamento
    // termine antes que o código continue (ex: antes de navegar)
    await _saveCollection();

    notifyListeners();
  }

  // =================================================================
  // FIM DA CORREÇÃO
  // =================================================================

  void resetGame() {
    currentMonster = null;
    playerHP = 100;
    monsterHP = 1;
    hand.clear();
    discardPile.clear();
    playerDeck.clear();
    currentRewards.clear();
    monsterDebuffs.clear();
    isPlayerTurn = true;
    gameMessage = null;
    gameState = GameState.playing;
    
    // Limpa o estado salvo da batalha
    _prefs.remove(_gameStateKey);
    
    notifyListeners();
  }

  bool get mounted => true;
}