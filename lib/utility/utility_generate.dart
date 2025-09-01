import 'dart:math';
import 'dart:ui';

class UtilityGenerate {
  final Random _random = Random();
  
  Color randomColor() {
    return Color(
      (_random.nextDouble() * 0xFFFFFF).toInt(),
    ).withValues(alpha: 1.0);
  }

  int randomRange(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }
}
