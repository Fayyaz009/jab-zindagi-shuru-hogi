import 'package:pub_semver/pub_semver.dart';

class VersionHelper {
  /// Compares two version strings. Returns true if [current] is lower than [target].
  static bool isVersionLower(String current, String target) {
    if (current.isEmpty || target.isEmpty) return false;

    // 1. Try parsing with pub_semver package
    try {
      final currentVer = Version.parse(current);
      final targetVer = Version.parse(target);
      return currentVer < targetVer;
    } catch (_) {
      // 2. Fallback: Custom manual splitter logic
      return _manualCompare(current, target) < 0;
    }
  }

  /// Manually compares version strings as a fallback.
  /// Returns < 0 if v1 < v2, > 0 if v1 > v2, and 0 if they are equal.
  static int _manualCompare(String v1, String v2) {
    // Strip build metadata (+...) or prerelease labels (-...) for segment check
    final cleanV1 = v1.split('+')[0].split('-')[0];
    final cleanV2 = v2.split('+')[0].split('-')[0];

    final parts1 = cleanV1.split('.');
    final parts2 = cleanV2.split('.');

    final maxLength = parts1.length > parts2.length ? parts1.length : parts2.length;

    for (int i = 0; i < maxLength; i++) {
      final val1 = i < parts1.length ? int.tryParse(parts1[i]) ?? 0 : 0;
      final val2 = i < parts2.length ? int.tryParse(parts2[i]) ?? 0 : 0;

      if (val1 < val2) return -1;
      if (val1 > val2) return 1;
    }

    // Fallback: If version segments match, compare build numbers if specified after '+'
    final build1 = _getBuildNumber(v1);
    final build2 = _getBuildNumber(v2);
    return build1.compareTo(build2);
  }

  static int _getBuildNumber(String version) {
    final parts = version.split('+');
    if (parts.length > 1) {
      return int.tryParse(parts[1]) ?? 0;
    }
    return 0;
  }
}
