import 'package:flutter_test/flutter_test.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/features/update/utils/version_helper.dart';

void main() {
  group('VersionHelper Semantic Version Comparison Tests', () {
    test('Should return true when current version is lower than target', () {
      expect(VersionHelper.isVersionLower('1.0.0', '1.1.0'), isTrue);
      expect(VersionHelper.isVersionLower('1.0.3', '1.0.4'), isTrue);
      expect(VersionHelper.isVersionLower('0.9.9', '1.0.0'), isTrue);
      expect(VersionHelper.isVersionLower('1.2.3', '2.0.0'), isTrue);
    });

    test(
      'Should return false when current version is equal or higher than target',
      () {
        expect(VersionHelper.isVersionLower('1.1.0', '1.0.0'), isFalse);
        expect(VersionHelper.isVersionLower('1.0.3', '1.0.3'), isFalse);
        expect(VersionHelper.isVersionLower('2.0.0', '1.2.3'), isFalse);
      },
    );

    test('Should handle build number metadata comparisons (+buildNumber)', () {
      expect(VersionHelper.isVersionLower('1.0.3+3', '1.0.3+4'), isTrue);
      expect(VersionHelper.isVersionLower('1.0.3+5', '1.0.3+4'), isFalse);
      expect(VersionHelper.isVersionLower('1.0.3+3', '1.0.4+1'), isTrue);
    });

    test(
      'Should fall back gracefully to manual parser if semver parsing fails',
      () {
        // Invalid semver strings that can still be parsed manually by segments
        expect(VersionHelper.isVersionLower('1.0.0.1', '1.0.0.2'), isTrue);
        expect(VersionHelper.isVersionLower('1.0', '1.1'), isTrue);
        expect(VersionHelper.isVersionLower('2.0', '1.9.9'), isFalse);
      },
    );
  });
}
