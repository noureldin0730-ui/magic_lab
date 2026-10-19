import 'package:flutter/material.dart';
import '../data/chemistry_data.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  String? _firstChemical;
  String? _secondChemical;
  Reaction? _currentReaction;
  bool _isExploding = false;
  String _statusText = 'اختار مادتين عشان تتفاعلوا';

  void _addChemical(Chemical chem) {
    if (_isExploding) return; // مينفعش يضيف وهو بينفجر

    setState(() {
      if (_firstChemical == null) {
        _firstChemical = chem.id;
        _statusText = 'ضفت ${chem.name}.. اختار المادة التانية';
      } else if (_secondChemical == null && chem.id != _firstChemical) {
        _secondChemical = chem.id;
        _checkReaction();
      }
    });
  }

  void _checkReaction() {
    final reaction = ChemistryData.getReaction(_firstChemical, _secondChemical);

    if (reaction != null) {
      setState(() {
        _currentReaction = reaction;
        _statusText = reaction.resultText;
        if (reaction.isExplosion) {
          _isExploding = true;
          _triggerExplosion();
        }
      });
    } else {
      setState(() {
        _currentReaction = null;
        _statusText = 'مفيش تفاعل! المادتين دول مش بيتفاعلوا مع بعض.';
      });
      // تصفير بعد شوية
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _reset();
      });
    }
  }

  void _triggerExplosion() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isExploding = false;
        });
        _reset();
      }
    });
  }

  void _reset() {
    setState(() {
      _firstChemical = null;
      _secondChemical = null;
      _currentReaction = null;
      _statusText = 'اختار مادتين عشان تتفاعلوا';
    });
  }

  @override
  Widget build(BuildContext context) {
    // بنجيب ألوان المواد اللي اتحطت
    final color1 = ChemistryData.chemicals.firstWhere((c) => c.id == _firstChemical, orElse: () => ChemistryData.chemicals[0]).color;
    final color2 = ChemistryData.chemicals.firstWhere((c) => c.id == _secondChemical, orElse: () => ChemistryData.chemicals[0]).color;

    // اللون النهائي للسائل
    final liquidColor = _currentReaction != null 
        ? Color(_currentReaction!.resultColor) 
        : ( _secondChemical != null ? Color(color2) : (_firstChemical != null ? Color(color1) : Colors.transparent));

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset('assets/images/lab_bg.png', fit: BoxFit.cover),
          ),
          
          // تأثير الانفجار (وميض أحمر)
          if (_isExploding)
            Positioned.fill(
              child: Container(color: Colors.red.withOpacity(0.5)),
            ),

          // المحتوى
          SafeArea(
            child: Column(
              children: [
                // العنوان
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'المعمل السحري',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 10)],
                    ),
                  ),
                ),

                // منطقة الأنبوبة
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: 250,
                      height: 400,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // الأنبوبة الزجاجية
                          Image.asset('assets/images/test_tube.png', fit: BoxFit.contain),
                          
                          // السائل اللي جوه
                          if (liquidColor != Colors.transparent && !_isExploding)
                            Positioned(
                              bottom: 40,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                width: 120,
                                height: _secondChemical != null ? 200 : 100, // بيزيد لما نحط المادة التانية
                                decoration: BoxDecoration(
                                  color: liquidColor,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: liquidColor,
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // الفقاعات (لو التفاعل فيه فقاعات)
                          if (_currentReaction != null && _currentReaction!.hasBubbles)
                            Positioned(
                              bottom: 80,
                              child: Image.asset('assets/images/bubbles.png', width: 150),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // شريط الحالة
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                  ),
                  child: Text(
                    _statusText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                // أزرار المواد
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: ChemistryData.chemicals.length,
                      itemBuilder: (_, i) {
                        final chem = ChemistryData.chemicals[i];
                        return GestureDetector(
                          onTap: () => _addChemical(chem),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(chem.color).withOpacity(0.8), width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(chem.emoji, style: const TextStyle(fontSize: 24)),
                                Text(chem.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}