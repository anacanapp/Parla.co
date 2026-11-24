import 'package:flutter_test/flutter_test.dart';
import 'package:parla/ui/text_case.dart';

void main() {
  test('Azerbaijani keeps the dot on İ and drops it on I', () {
    expect(upperCaseIn('az', 'reseptlər · ıslaq'), 'RESEPTLƏR · ISLAQ');
    expect(upperCaseIn('az', 'İdman, qidalanma'), 'İDMAN, QİDALANMA');
  });

  test('Russian and English use the plain upper case', () {
    expect(upperCaseIn('en', 'tip of the day'), 'TIP OF THE DAY');
    expect(upperCaseIn('ru', 'рецепт'), 'РЕЦЕПТ');
  });
}
