class UpdateConfig {
  final String minRequiredVersion;
  final String latestVersion;
  final String updateUrl;
  final bool forceUpdateOverride;
  final String title;
  final String updateMessage;

  const UpdateConfig({
    required this.minRequiredVersion,
    required this.latestVersion,
    required this.updateUrl,
    required this.forceUpdateOverride,
    required this.title,
    required this.updateMessage,
  });

  /// Parses the configuration from the top-level map based on the platform.
  /// Standard platforms: 'android' or 'ios'.
  factory UpdateConfig.fromJson(Map<String, dynamic> json, String platform) {
    final platformJson = json[platform] as Map<String, dynamic>? ?? {};
    final defaultUrl = platform == 'android'
        ? 'https://play.google.com/store/apps/details?id=com.jabzindagishuruhogi.inzaar'
        : 'https://apps.apple.com/app/id6475653457'; // Replace with iOS App Store link if needed
    
    return UpdateConfig(
      minRequiredVersion: platformJson['min_required_version'] as String? ?? '1.0.0',
      latestVersion: platformJson['latest_version'] as String? ?? '1.0.0',
      updateUrl: (platformJson['update_url'] as String?)?.isNotEmpty == true
          ? platformJson['update_url'] as String
          : defaultUrl,
      forceUpdateOverride: platformJson['force_update'] as bool? ?? false,
      title: platformJson['title'] as String? ?? 'Update Available',
      updateMessage: platformJson['update_message'] as String? ?? 'Please update to the latest version for the best experience.',
    );
  }

  @override
  String toString() {
    return 'UpdateConfig(minRequiredVersion: $minRequiredVersion, latestVersion: $latestVersion, updateUrl: $updateUrl, forceUpdateOverride: $forceUpdateOverride, title: $title, updateMessage: $updateMessage)';
  }
}
