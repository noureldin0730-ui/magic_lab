class Chemical {
  final String id;
  final String name;
  final String emoji;
  final int color;

  const Chemical({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class Reaction {
  final String chem1;
  final String chem2;
  final String resultText;
  final int resultColor;
  final bool isExplosion;
  final bool hasBubbles;

  const Reaction({
    required this.chem1,
    required this.chem2,
    required this.resultText,
    required this.resultColor,
    this.isExplosion = false,
    this.hasBubbles = false,
  });
}

class ChemistryData {
  // قائمة المواد الكيميائية
  static const List<Chemical> chemicals = [
    Chemical(id: 'water', name: 'ماء', emoji: '💧', color: 0x884A90E2),
    Chemical(id: 'vinegar', name: 'خل', emoji: '🍶', color: 0x88E8E8C0),
    Chemical(id: 'baking_soda', name: 'بيكربونات', emoji: '🧂', color: 0x88F5F5DC),
    Chemical(id: 'oxide', name: 'أكسيد', emoji: '🌫️', color: 0x888A8A8A),
    Chemical(id: 'sulfur', name: 'كبريت', emoji: '🔥', color: 0x88FFD54A),
    Chemical(id: 'soda', name: 'صودا كاوية', emoji: '🧪', color: 0x88FFFFFF),
    Chemical(id: 'magnesium', name: 'ماغنسيوم', emoji: '✨', color: 0x88C0C0C0),
    Chemical(id: 'potassium', name: 'بوتاسيوم', emoji: '💥', color: 0x88A8A8A8),
  ];

  // قائمة التفاعلات
  static const List<Reaction> reactions = [
    Reaction(
      chem1: 'vinegar',
      chem2: 'baking_soda',
      resultText: 'فوران ورغاوي! غاز ثاني أكسيد الكربون اتصاعد.',
      resultColor: 0xCCF5F5DC,
      hasBubbles: true,
    ),
    Reaction(
      chem1: 'water',
      chem2: 'oxide',
      resultText: 'حرارة وبخار! الأكسيد اتفاعل مع الماء وطلع حرارة.',
      resultColor: 0xCCAAAAAA,
    ),
    Reaction(
      chem1: 'water',
      chem2: 'sulfur',
      resultText: 'المية بقت صفرا! تكوّن حمض الكبريتيك الضعيف.',
      resultColor: 0xCCFFE88A,
    ),
    Reaction(
      chem1: 'water',
      chem2: 'potassium',
      resultText: 'انفجار! البوتاسيوم اشتعل مع الماء وطلع لهب بنفسجي.',
      resultColor: 0xCCFF3333,
      isExplosion: true,
    ),
    Reaction(
      chem1: 'water',
      chem2: 'magnesium',
      resultText: 'وميض أبيض ساطع! الماغنسيوم اشتعل بضوء قوي.',
      resultColor: 0xCCFFFFFF,
      isExplosion: true,
    ),
    Reaction(
      chem1: 'vinegar',
      chem2: 'soda',
      resultText: 'تفاعل كيميائي قوي! الحرارة زادت والسائل اتحول للون الأصفر.',
      resultColor: 0xCCFFD54A,
    ),
    Reaction(
      chem1: 'sulfur',
      chem2: 'oxide',
      resultText: 'دخان رمادي كثيف! تكوّن مركب كبريتي.',
      resultColor: 0xCC555555,
    ),
  ];

  // دالة البحث عن التفاعل
  static Reaction? getReaction(String? c1, String? c2) {
    if (c1 == null || c2 == null || c1 == c2) return null;

    for (var r in reactions) {
      if ((r.chem1 == c1 && r.chem2 == c2) || (r.chem1 == c2 && r.chem2 == c1)) {
        return r;
      }
    }
    return null;
  }
}