import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/update_config.dart';

class SoftUpdateDialog extends StatelessWidget {
  final UpdateConfig config;

  const SoftUpdateDialog({
    super.key,
    required this.config,
  });

  static const String _lastDismissedKey = 'soft_update_last_dismissed';

  /// Throttles showing the soft update prompt to once every 24 hours.
  /// Returns `true` if it's fine to show, or `false` if it should be skipped.
  static Future<bool> shouldShowPrompt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastDismissedMs = prefs.getInt(_lastDismissedKey);
      if (lastDismissedMs == null) return true;

      final lastDismissedTime = DateTime.fromMillisecondsSinceEpoch(lastDismissedMs);
      final now = DateTime.now();
      
      // Delay prompt for 24 hours
      return now.difference(lastDismissedTime).inHours >= 24;
    } catch (_) {
      // Default to showing if error reading cache
      return true;
    }
  }

  /// Records the current timestamp of user dismissal in [SharedPreferences].
  static Future<void> recordDismissal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastDismissedKey, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {
      // Ignore cache write errors in runtime
    }
  }

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final uri = Uri.parse(config.updateUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch URL';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Link open nahi ho saka. Play Store check karein.',
              style: TextStyle(fontFamily: 'Urdu', fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentGold = Color(0xFFC5A358); // Premium gold
    const cardDark = Color(0xFF1A1F3C); // Custom deep dark card background

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: cardDark,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Glimmer icon header
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentGold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: accentGold,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Title
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urdu',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            /// Message
            Text(
              config.updateMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urdu',
                fontSize: 16,
                color: Color(0xFFB0B3C7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            /// Action Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await recordDismissal();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Later (Baad Mein)',
                      style: TextStyle(
                        fontFamily: 'Urdu',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _launchUpdateUrl(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGold,
                      foregroundColor: const Color(0xFF3E2723),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(
                        fontFamily: 'Urdu',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
